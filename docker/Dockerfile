# Pull image from docker hub
FROM nginxdemos/hello:0.4-plain-text

# Create a build argument that will dictate
# which template we copy into the container
# (the app one or the load balancer one)
ARG TEMPLATE_FILE

CMD ["/usr/sbin/sshd", "-D"]

EXPOSE 80 22

# Copy the template in
COPY ./$TEMPLATE_FILE /nginx.conf.template

# Configure SSH
COPY ./sshd_config /etc/sshd/sshd_config

# Copy the entrypoint in
COPY ./entrypoint.sh /entrypoint.sh

# Set entrypoint as runnable
RUN chmod +x /entrypoint.sh

# Set entrypoint.sh as entrypoint command for
# the container
ENTRYPOINT ["/entrypoint.sh"]