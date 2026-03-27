FROM nginx:latest
# Copy your HTML file into Nginx's default web directory
RUN rm -rf /usr/share/nginx/html/index.html
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80