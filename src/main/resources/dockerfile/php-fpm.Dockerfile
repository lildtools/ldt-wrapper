FROM debian:12.2

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y nginx php8.2-fpm
RUN apt-get autoremove -y

EXPOSE 80
