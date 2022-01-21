FROM nodetransit/fedora-haskell:latest

WORKDIR /root/project

RUN dnf install -y              \
        postgresql              \
        postgresql-contrib      \
        libpq-devel

RUN dnf install -y              \
        community-mysql-devel   \
        community-mysql
