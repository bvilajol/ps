
Ensure that your system is up to date and you have installed terraform and docker

# Docker image

Build the image

    cd docker && docker build . -t nginx --build-arg=TEMPLATE_FILE=nginx.app.conf.tmpl

Validate the image has been created

    docker image ls | grep nginx
    nginx      latest    bbb4d69e101d   34 seconds ago   52.5MB

# Terraform deployment

