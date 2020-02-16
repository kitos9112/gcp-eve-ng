FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN ln -fs /usr/share/zoneinfo/Eurpe/London /etc/localtime
RUN apt-get update && \
      apt-get -y install sudo coreutils curl make build-essential libssl-dev zlib1g-dev libbz2-dev \
                        libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
                        xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo curl

USER docker

CMD /bin/bash