# encoding: utf-8

require_dependency 'application_helper'

module RedmineFavoriteProjects
  module Patches
    module ApplicationHelperPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method_chain :render_project_jump_box, :only_favorites
        end
      end

      module InstanceMethods
        def render_project_jump_box_with_only_favorites
          favorite_projects = favorite_list
          return if favorite_projects.nil? || !favorite_projects.any?
          s = "<select onchange=\"if (this.value != '') { window.location = this.value; }\"> \
               <option value=\"\">#{l(:label_jump_to_a_project)}</option> \
               <option value=\"\" disabled=\"disabled\">---</option>"
          s << project_tree_options_for_select(favorite_projects, selected: @project) do |p|
            { value: url_for(controller: 'projects', action: 'show', id: p, jump: current_menu_item) }
          end
          s << '</select>'
          s.html_safe
        end
      end
    end
  end
end
