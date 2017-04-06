#!/bin/bash
if [ ! -d "${REDMINE_DATA_DIR}/tmp/" ]; then
  echo "INSTALANDO redmine POR PRIMERA VEZ------"
  sudo /sbin/entrypoint.sh 'echo "Instalando redmine de base"'
  echo "INSTALACIÓN INICIAL FINALIZADA------"
fi
if [ ! -d "${REDMINE_DATA_DIR}/plugins/" ]; then
  echo "Preparando plugins y temas de TEO..."
  sudo mv ${REDMINE_INSTALL_DIR}/teo-plugins ${REDMINE_DATA_DIR}/plugins
  sudo cp -r ${REDMINE_INSTALL_DIR}/public/themes ${REDMINE_DATA_DIR}
  if [ -d ${REDMINE_DATA_DIR}/plugins/redmine_omniauth_saml ]; then
    sudo /sbin/entrypoint.sh 'echo "Instalando plugins antes de configurar SAML"'
    sudo mv ${REDMINE_HOME}/teo-config/initializers/saml.rb ${REDMINE_INSTALL_DIR}/config/initializers/saml.rb
  fi
fi;
sudo service ssh start
if [ -e "${REDMINE_INSTALL_DIR}/config/environments/production.rb.orig" ]; then
  sudo cp "${REDMINE_INSTALL_DIR}/config/environments/production.rb.orig" "${REDMINE_INSTALL_DIR}/config/environments/production.rb"
fi
if [ "$TEO_ENV" = "development" ]; then
  echo "Linking to data-dir plugins"
  if [ -d "${REDMINE_DATA_DIR}/plugins/" ]; then
    sudo mv "${REDMINE_INSTALL_DIR}/plugins/" "${REDMINE_INSTALL_DIR}/plugins-orig/"
    sudo ln -s "${REDMINE_DATA_DIR}/plugins/" "${REDMINE_INSTALL_DIR}"
  fi
  echo "Disabling caches"
  if [ ! -e "${REDMINE_INSTALL_DIR}/config/environments/production.rb.orig" ]; then
    sudo cp "${REDMINE_INSTALL_DIR}/config/environments/production.rb" "${REDMINE_INSTALL_DIR}/config/environments/production.rb.orig"
  fi
  sudo cp "${REDMINE_INSTALL_DIR}/config/environments/development.rb" "${REDMINE_INSTALL_DIR}/config/environments/production.rb"
  echo "--- Activating DEBUG log level ---"
  echo "config.log_level = :debug" >> ${REDMINE_INSTALL_DIR}/config/additional_environment.rb
  mkdir -p log
  touch log/production.log
  tail -n0 -f log/production.log &
fi

sed '/ui_theme:/{n;s/.*/  default: teo_a1_theme/}' /home/redmine/redmine/config/settings.yml > /home/redmine/redmine/config/settings.yml.aux
cat /home/redmine/redmine/config/settings.yml.aux > /home/redmine/redmine/config/settings.yml

sudo /sbin/entrypoint.sh "$@"
