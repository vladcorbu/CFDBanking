FROM mariadb:10.5.5
ENV MYSQL_USER=user
ENV MYSQL_PASSWORD=password
ENV MYSQL_DATABASE=tranzactidb
ENV MYSQL_ROOT_PASSWORD=password
COPY init.sql /docker-entrypoint-initdb.d/

