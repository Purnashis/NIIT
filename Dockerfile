FROM wordpress:6.6.1


COPY ./niitcourses-sandbox/. /usr/src/wordpress/

COPY ./src/. /usr/src/wordpress/


ADD docker-entrypoint.sh /usr/local/bin/

RUN chmod 755 /usr/local/bin/docker-entrypoint.sh