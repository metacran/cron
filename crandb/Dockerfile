
FROM rhub/r-minimal:3.6

RUN installr -d -t curl-dev -a libcurl metacran/crandb@dbe8903

WORKDIR /root

ENV COUCHDB_USER=admin

COPY update-crandb.R .
