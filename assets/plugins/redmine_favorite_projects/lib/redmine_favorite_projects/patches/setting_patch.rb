# encoding: utf-8

module RedmineFavoriteProjects
  module Patches
    # Overwrite settings
    module SettingPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          after_save :clear_cache
        end
      end
    end

    # Add instance methods for Setting module
    module InstanceMethods
      private

      def clear_cache
        # Only validate settings for our plugin
        return unless name == 'plugin_redmine_favorite_projects'
        Rails.cache.clear
      end
    end
  end
end

unless Setting.included_modules.include?(RedmineFavoriteProjects::Patches::SettingPatch)
  Setting.send(:include, RedmineFavoriteProjects::Patches::SettingPatch)
end
