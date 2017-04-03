class AddProjectNameView < ActiveRecord::Migration
  def change
    add_column :projects, :project_name_view, :string, default: '0'
  end

  def self.down
    remove_column :projects, :project_name_view
  end
end
