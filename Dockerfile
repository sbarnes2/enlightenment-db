FROM postgres:16-bookworm 

COPY initdb.pg.sql /docker-entrypoint-initdb.d/

EXPOSE 5432:5432

