# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mdenys <mdenys@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/01/06 14:49:21 by mdenys            #+#    #+#              #
#    Updated: 2021/01/08 15:22:02 by mdenys           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster
LABEL maintainer="mdenys"
RUN apt-get update && apt-get install -y procps && apt-get install nano && apt-get install -y wget && apt-get install -y unzip && apt-get install -y curl
RUN apt install apt-transport-https lsb-release ca-certificates wget -y
RUN apt-get -y install php7.3-fpm php7.3-common php7.3-mysql php7.3-gmp php7.3-curl php7.3-intl php7.3-mbstring php7.3-xmlrpc php7.3-gd php7.3-xml php7.3-cli php7.3-zip php7.3-soap php7.3-imap
RUN apt-get install -y nginx
RUN apt-get install -y mc
RUN apt-get install -y mariadb-server
COPY ./srcs/php.ini ./
COPY ./srcs/nginx.conf /etc/nginx/sites-available/
COPY ./srcs/settings.sh ./
RUN  mkdir /var/www/html/phpmyadmin
RUN  wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz
RUN  tar -xvf phpMyAdmin-5.0.4-all-languages.tar.gz --strip-components 1 -C /var/www/html/phpmyadmin
COPY ./srcs/phpmyadmin.inc.php /var/www/html/phpmyadmin/
CMD bash ./settings.sh
EXPOSE 80 443 3306
