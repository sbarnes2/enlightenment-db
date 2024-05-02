FROM postgres:16-alpine 

COPY initdb.pg.sql /docker-entrypoint-initdb.d/

EXPOSE 5432

