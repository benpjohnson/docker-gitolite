IMAGE=benpjohnson/git
CMD=docker run -v /var/lib/data/git:/home/git/ --entrypoint=/bin/bash $(IMAGE) -c

build :
	docker build -t $(IMAGE) .
push :
	docker push $(IMAGE)

run :
	docker run -d -v /var/lib/data/git:/home/git/ -p 2020:22 $(IMAGE)

bash :
	docker run -it -v /var/lib/data/git:/home/git/ $(IMAGE) /bin/bash

setup : chmod-home ssh-setup gitolite-setup /var/lib/data/git

# add-key

chmod-home :
	 $(CMD) "chown git:git /home/git" 

ssh-setup :
	 $(CMD) "su git -c 'mkdir /home/git/.ssh/ && touch /home/git/.ssh/authorized_keys && ssh-keygen -f /home/git/.ssh/id_rsa -N \"\"'"

gitolite-setup :
	 $(CMD) "su git -c 'mkdir /home/git/gitolite-admin/ && /usr/bin/gl-setup -q /home/git/.ssh/id_rsa.pub && chmod 600 /home/git/.ssh/authorized_keys'"

# Get local connections into known hosts so we can run admin stuff
# RUN /usr/sbin/sshd && su git -c 'ssh-keyscan -H localhost > /home/git/.ssh/known_hosts'

# should be part of setup
build-admin : add-known-hosts
	 $(CMD) "/usr/sbin/sshd && su git -c 'git clone git@localhost:gitolite-admin.git /home/git/gitolite-admin/'"

add-known-hosts :
	$(CMD) "/usr/sbin/sshd && su git -c 'ssh-keyscan -H localhost > /home/git/.ssh/known_hosts'"


# Push keys from the local repo

push-key :
	$(CMD) "/usr/sbin/sshd && su git -c 'cd /home/git/gitolite-admin/ && git push'"

/var/lib/data/git :
	mkdir -p /var/lib/data/git
