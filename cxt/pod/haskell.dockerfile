FROM nodetransit/opensuse-haskell:latest

WORKDIR /root/project

RUN zypper install -y                \
           postgresql14              \
           postgresql14-contrib      \
           postgresql14-server       \
           postgresql14-server-devel \
           libpqxx-devel

#RUN dnf install -y              \
#        community-mysql-devel   \
#        community-mysql

