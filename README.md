
Ensure that your system is up to date and you have installed terraform and docker

# Docker image

Build the image

    cd docker && docker build . -t nginx --build-arg=TEMPLATE_FILE=nginx.app.conf.tmpl

Validate the image has been created

    docker image ls | grep nginx
    nginx      latest    bbb4d69e101d   34 seconds ago   52.5MB

# Terraform deployment

Init terraform

    cd ../terraform
    terraform init

Deploy

    terraform apply

# Validate deployment

Docker instances must be up and running

    sudo docker ps
    CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                          NAMES
    cde9aa6beb0e   f245f6aa77f3   "/entrypoint.sh /usr…"   6 seconds ago   Up 6 seconds   22/tcp, 0.0.0.0:8080->80/tcp   nginx-lb
    c13f4018b981   976881840042   "/entrypoint.sh /usr…"   7 seconds ago   Up 6 seconds   22/tcp, 80/tcp                 nginx-0
    e1295348c05d   976881840042   "/entrypoint.sh /usr…"   7 seconds ago   Up 6 seconds   22/tcp, 80/tcp                 nginx-1

Run script for testing the web-servers

    /test.sh 
    HELLO WORLD FROM SERVER 1
    HELLO WORLD FROM SERVER 2
    HELLO WORLD FROM SERVER 1
    HELLO WORLD FROM SERVER 2
    ...

# Shutdown deployment

    terraform destroy