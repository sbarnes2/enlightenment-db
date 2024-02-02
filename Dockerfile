FROM postgres:16-alpine 

COPY training.sql /docker-entrypoint-initdb.d/

EXPOSE 5432

