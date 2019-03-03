FROM wordpress:latest

# Add some labels
LABEL comp="web"

# Set a variable that we will keep reusing to prevent typos
ENV WORDPRESS_DB_HOST=db:3306
ENV WORDPRESS_DB_USER=wordpress
ENV WORDPRESS_DB_PASSWORD=wordpress
ENV WORDPRESS_DB_NAME=wordpress

#Expost Web port
EXPOSE 80/tcp
