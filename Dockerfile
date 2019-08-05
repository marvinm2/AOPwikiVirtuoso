FROM busybox:latest
ENV APP_ROOT /code
WORKDIR /data
COPY AOPWikiRDF.ttl .
COPY AOPWikiRDF.ttl.graph .
COPY AOPWikiRDF-Void.ttl .
COPY AOPWikiRDF-Void.ttl.graph .
COPY docker-entrypoint.sh ${APP_ROOT}/
WORKDIR ${APP_ROOT}
CMD sh docker-entrypoint.sh
