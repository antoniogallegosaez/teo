FROM sameersbn/redmine:3.1.1-3
MAINTAINER juan.leal@juntadeandalucia.es

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server libxml2-dev libxslt1.1 libxslt1-dev build-essential libssh2-1 libssh2-1-dev cmake libgpg-error-dev

RUN mkdir ${REDMINE_HOME}/teo-plugins
COPY assets/themes/ ${REDMINE_INSTALL_DIR}/public/themes
COPY assets/plugins ${REDMINE_INSTALL_DIR}/teo-plugins
COPY assets/setup/sudoers /etc/sudoers.d/redmine
COPY assets/setup/saml.rb ${REDMINE_HOME}/teo-config/initializers/saml.rb

# Para redmine_git_hosting
RUN adduser --disabled-password --gecos git git
RUN su - ${GITOLITE_USER} -c " \
 mkdir -p ${GITOLITE_HOME}/bin; \
 git clone https://github.com/sitaramc/gitolite.git; \
 gitolite/install -to ${GITOLITE_HOME}/bin"
RUN update-rc.d ssh defaults

RUN cd ${REDMINE_INSTALL_DIR}/teo-plugins \
 && git clone https://github.com/jbox-web/redmine_bootstrap_kit.git \
 && cd redmine_bootstrap_kit/ \
 && git checkout 0.2.4 \
 && cd ${REDMINE_INSTALL_DIR}/teo-plugins \
 && git clone https://github.com/jbox-web/redmine_git_hosting.git \
 && cd redmine_git_hosting/ \
 && git checkout 1.2.0 \
 && grep -rl "gem 'dalli'" . | xargs sed -i "s/gem 'dalli'/#gem 'dalli'/g"

COPY assets/setup/restart /sbin/restart
RUN chmod 755 /sbin/restart
EXPOSE 80/tcp 443/tcp 22/tcp
VOLUME ["${REDMINE_DATA_DIR}", "${REDMINE_LOG_DIR}"]
COPY teo-entrypoint.sh /sbin/teo-entrypoint.sh
RUN chmod 755 /sbin/teo-entrypoint.sh
WORKDIR ${REDMINE_INSTALL_DIR}
ENTRYPOINT ["/sbin/teo-entrypoint.sh"]
CMD ["app:start"]

