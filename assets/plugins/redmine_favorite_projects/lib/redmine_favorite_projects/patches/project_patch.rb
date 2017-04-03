# encoding: utf-8

require_dependency 'project'

module RedmineFavoriteProjects
  module Patches
    module ProjectPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          safe_attributes 'project_name_view'
          before_save :clear_favorite_project_cache
        end
      end
    end

    # Add instance methods for Project module
    module InstanceMethods
      private

      def clear_favorite_project_cache
        Rails.cache.clear if changed?
      end
    end
  end
end
