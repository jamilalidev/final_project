FROM nginx:1.22.1


RUN apt-get update && apt-get install -y \
	logrotate \
	nginx-extras \
	libpam-mysql \
	&& rm -rf /var/lib/apt/lists*

RUN  apt-get clean

# Set the number of worker processes by copying the nginx.conf file
COPY nginx.conf /etc/nginx/nginx.conf

#http to https redirect
COPY default.conf /etc/nginx/conf.d/default.conf


# Enable access logs and specify the log location
RUN mkdir -p /var/log/nginx
RUN touch /var/log/nginx/jamilaali_com_access.log
RUN chmod 644 /var/log/nginx/jamilaali_com_access.log

# Copy your custom index.html file
COPY index.html /usr/share/nginx/html/index.html
RUN chmod 644 /usr/share/nginx/html/index.html


#Log rotation
COPY nginx-logrotate /etc/logrotate.d/nginx-logrotate

# Create the /etc/nginx/ssl directory
RUN mkdir -p /etc/nginx/ssl

# Generate a self-signed certificate without user interaction
RUN openssl req -x509 -newkey rsa:4096 -nodes -out /etc/nginx/ssl/server.crt \
	-keyout /etc/nginx/ssl/server.key -days 365 \
	-subj "/C=AZ/ST=Baku/L=Baku/OU=NO/CN=jamilaali.com"
#/srv
RUN mkdir -p /srv
COPY *.txt /srv/

COPY my_nginx /etc/pam.d/my_nginx

