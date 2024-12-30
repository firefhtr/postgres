FROM registry.suse.com/bci/bci-base:15.5
LABEL maintainer="Anthony Tortola <atortola@suse.com>"

ARG repo
ARG cert

RUN echo "$cert" > /etc/pki/trust/anchors/RHN-ORG-TRUSTED-SSL-CERT.pem
RUN update-ca-certificates
RUN echo "$repo" > /etc/zypp/repos.d/susemanager:dockerbuild.repo

RUN zypper --gpg-auto-import-keys ref -s
RUN zypper in -y postgresql15-server

RUN chown -v postgres:postgres /var/lib/pgsql/

USER postgres

RUN initdb -D /var/lib/pgsql/data

RUN echo "host    all             all             0.0.0.0/0               md5" >> /var/lib/pgsql/data/pg_hba.conf
RUN echo "listen_addresses='*'"  >> /var/lib/pgsql/data/postgresql.conf

EXPOSE 5432

CMD pg_ctl -D /var/lib/pgsql/data start &
