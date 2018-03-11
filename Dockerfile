FROM debian:jessie
MAINTAINER marcello.desales@gmail.com

# Install dependencies and setup locales
RUN apt-get update -q && apt-get install -y --no-install-recommends \
    git-core openssh-server locales curl \
        && dpkg-reconfigure locales \
        && locale-gen C.UTF-8 \
        && /usr/sbin/update-locale LANG=C.UTF-8 \
        && echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
        && locale-gen

# Set default locale for the environment
ENV LC_ALL=C.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

# Setup gitreceive
#add     https://raw.github.com/progrium/gitreceive/master/gitreceive /usr/local/bin/
ADD gitreceive /usr/local/bin/
ADD receiver /home/git/receiver
RUN chmod 755 /usr/local/bin/gitreceive /home/git/receiver \
        usr/local/bin/gitreceive \
        && mkdir /var/run/sshd

RUN /usr/local/bin/gitreceive init

ADD sshkey.pub /root/.ssh/authorized_keys
RUN chown root:root /root/.ssh/authorized_keys

VOLUME /home/git

EXPOSE  22

entrypoint ["/usr/sbin/sshd", "-D"]
