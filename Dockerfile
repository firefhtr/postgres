FROM registry.suse.com/suse/postgres:latest
LABEL maintainer="Anthony Tortola <atortola@suse.com>"

USER postgres

RUN initdb -D /var/lib/pgsql/data

RUN echo "host    all             all             0.0.0.0/0               md5" >> /var/lib/pgsql/data/pg_hba.conf
RUN echo "listen_addresses='*'"  >> /var/lib/pgsql/data/postgresql.conf

EXPOSE 5432

RUN pg_ctl -D /var/lib/pgsql/data -l logfile start &
