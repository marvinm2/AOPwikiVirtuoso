FROM busybox:latest
ENV APP_ROOT /code
WORKDIR /data
COPY aopwiki.ttl .
COPY docker-entrypoint.sh ${APP_ROOT}/
VOLUME /data
