FROM mysql:5.7

# Add some labels
LABEL comp="db"

# Set a variable that we will keep reusing to prevent typos
ENV MYSQL_ROOT_PASSWORD=password
ENV MYSQL_DATABASE=wordpress
ENV MYSQL_USER=user
ENV MYSQL_PASSWORD=password

# Define ./external as an externally-mounted directory
VOLUME /var/lib/mysql

