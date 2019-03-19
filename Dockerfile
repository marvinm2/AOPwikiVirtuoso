FROM busybox:latest
ENV APP_ROOT /code
WORKDIR /data
COPY aopwiki.ttl .
COPY aopwiki.ttl.graph .
COPY docker-entrypoint.sh ${APP_ROOT}/
WORKDIR ${APP_ROOT}
CMD sh docker-entrypoint.sh
