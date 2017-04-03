#!/bin/bash

echo "Checking if must install ssh client keys..."
REDMINE_DOTFILES_DIR=${REDMINE_DATA_DIR}/dotfiles
if [[ -e ${REDMINE_DOTFILES_DIR}/.ssh/id_rsa && -e ${REDMINE_DOTFILES_DIR}/.ssh/id_rsa.pub ]]; then
  echo "- Certificates present in " ${REDMINE_DOTFILES_DIR}/.ssh
fi

if [[ -d "${REDMINE_INSTALL_DIR}/plugins/redmine_git_hosting" ]]; then
  echo "- Target dir present in " ${REDMINE_INSTALL_DIR}/plugins/
else
  echo "- Target dir not present"
  ls -l ${REDMINE_INSTALL_DIR}/plugins
fi

if [[ -e ${REDMINE_DOTFILES_DIR}/.ssh/id_rsa && -e ${REDMINE_DOTFILES_DIR}/.ssh/id_rsa.pub && -d "${REDMINE_INSTALL_DIR}/plugins/redmine_git_hosting" ]]; then
  echo "Installing ssh client keys to redmine gitolite plugin and gitolite itself"
  cp ${REDMINE_DOTFILES_DIR}/.ssh/id_rsa.pub /home/git/redmine_gitolite_admin_id_rsa.pub
  cp ${REDMINE_DOTFILES_DIR}/.ssh/id_rsa.pub ${REDMINE_INSTALL_DIR}/plugins/redmine_git_hosting/ssh_keys/redmine_gitolite_admin_id_rsa.pub
  cp ${REDMINE_DOTFILES_DIR}/.ssh/id_rsa ${REDMINE_INSTALL_DIR}/plugins/redmine_git_hosting/ssh_keys/redmine_gitolite_admin_id_rsa
  chown ${REDMINE_USER}:${REDMINE_USER} ${REDMINE_INSTALL_DIR}/plugins/redmine_git_hosting/ssh_keys/*
  chown git /home/git/redmine_gitolite_admin_id_rsa.pub
  su - git -c "gitolite setup -pk redmine_gitolite_admin_id_rsa.pub"

  echo "Configuring gitolite"
  sed -i.orig "s/GIT_CONFIG_KEYS *=> *'',/GIT_CONFIG_KEYS  =>  '.*',/" /home/git/.gitolite.rc
  sed -i 's/# *LOCAL_CODE *=> *"$ENV{HOME}\/local"/LOCAL_CODE => "$ENV{HOME}\/local"/' /home/git/.gitolite.rc
  su - redmine -c "ssh-keyscan localhost >> ~/.ssh/known_hosts"
fi;

