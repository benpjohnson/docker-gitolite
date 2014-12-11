FROM debian:wheezy

# Required packages
RUN apt-get update && apt-get install -y git openssh-server git gitolite debconf locales

# Setup a git user
RUN useradd -m git 

RUN mkdir /var/run/sshd 

# Expose the required port
EXPOSE 22

# Install gitolite
#RUN su git -c 'mkdir /home/git/'

#RUN su git -c 'mkdir /home/git/.ssh/ && touch /home/git/.ssh/authorized_keys && ssh-keygen -f /home/git/.ssh/id_rsa -N "" && mkdir /home/git/gitolite-admin/ && gl-setup -q /home/git/.ssh/id_rsa.pub' && chmod 600 /home/git/.ssh/authorized_keys

# Get local connections into known hosts so we can run admin stuff
#RUN /usr/sbin/sshd && su git -c 'ssh-keyscan -H localhost > /home/git/.ssh/known_hosts'

# fix locales
RUN update-locale LANG=en_GB LC_ALL=C

# Expose all the git stuff
VOLUME /home/git/

CMD ["/usr/sbin/sshd", "-D"]
