# encoding: utf-8

Redmine::Plugin.register :redmine_favorite_projects do
  name 'Redmine Favorite Projects plugin'
  description 'This is a favorite projects plugin for Redmine'
  version '1.0.5'
  url 'https://github.com/alexandermeindl/redmine_favorite_projects'
  author 'RedmineCRM, AlphaNodes GmbH'

  requires_redmine version_or_higher: '3.0.0'

  default_settings = {
    'default_favorite_behavior' => false,
    'show_in_app_menu' => false,
    'project_name_view' => '1',
    'show_project_manager' => false,
    'project_manager_name' => 'Manager',
    'show_project_modules' => false,
    'show_project_progress' => false,
    'show_project_desc' => true,
    'show_project_homepage' => true,
    'show_project_created_on' => true
  }
  settings(default: default_settings, partial: 'settings/favorite_projects')

  menu :application_menu, :favorite_menu, '',
       caption: '',
       html: { id: 'favorite-menu' },
       param: :project_id,
       last: true,
       if: proc { User.current.logged? && Setting.plugin_redmine_favorite_projects['show_in_app_menu'] }
end

require 'redmine_favorite_projects'
