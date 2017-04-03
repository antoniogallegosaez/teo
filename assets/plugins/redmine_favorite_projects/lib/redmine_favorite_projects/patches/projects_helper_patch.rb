# encoding: utf-8

module RedmineFavoriteProjects
  module Patches
    module ProjectsHelperPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
      end

      module InstanceMethods
        include FavoriteProjectsHelper
      end
    end
  end
end
