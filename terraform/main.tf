/* Terraform settings */

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.0"
    }
  }
}

/* Docker provider settings */
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

/* Input variables */
variable "external_port" {
  default     = 8080
  type        = number
  description = "The external port that our load balancer will be listening"
}

variable "num_server_apps" {
  default     = 2
  type        = number
  description = "The number of app instances."
}

locals {
  nginx_base_path  = "${path.module}/../docker"
  server_block_arr = [for d in docker_container.nginx_apps : "server ${d.name}"]
}

/* Docker images */
resource "docker_image" "nginx_app" {
  name = "nginxapp"

  triggers = {
    dir_sha1 = sha1(
      join(
        "",
        [for f in fileset(local.nginx_base_path, "*") : filesha1("${local.nginx_base_path}/${f}")]
      )
    )
  }

  build {
    path = local.nginx_base_path
    tag  = ["nginxapp:latest"]
    build_arg = {
      TEMPLATE_FILE : "nginx.app.conf.tmpl"
    }
  }
}

resource "docker_image" "nginx_lb" {
  name = "nginxlb"

  triggers = {
    dir_sha1 = sha1(
      join(
        "",
        [for f in fileset(local.nginx_base_path, "*") : filesha1("${local.nginx_base_path}/${f}")]
      )
    )
  }

  build {
    path = local.nginx_base_path
    tag  = ["nginxlb:latest"]
    build_arg = {
      TEMPLATE_FILE : "nginx.lb.conf.tmpl"
    }
  }
}


/* Docker network */
resource "docker_network" "nginx_network" {
  name = "nginx"
}

/* Docker containers */
resource "docker_container" "nginx_apps" {
  count = var.num_server_apps
  name  = "nginx-${count.index}"
  image = docker_image.nginx_app.image_id
  env   = ["MESSAGE=HELLO WORLD FROM SERVER ${count.index+1}"]

  networks_advanced {
    name = docker_network.nginx_network.id
  }
}

resource "docker_container" "nginx_lb" {
  name  = "nginx-lb"
  image = docker_image.nginx_lb.image_id

  env = [
    "SERVERS=${join(";", local.server_block_arr)}",
  ]

  ports {
    external = var.external_port
    internal = "80"
  }

  networks_advanced {
    name = docker_network.nginx_network.id
  }

}
