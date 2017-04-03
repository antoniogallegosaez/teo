class TeoSetupSettingsController < ApplicationController
  unloadable


  def erase
    Setting.destroy_all
    Setting.clear_cache
    Tracker.destroy_all
    Enumeration.destroy_all
    IssueStatus.destroy_all
    Role.where(:builtin => 0).destroy_all
    AuthSourceLdap.destroy_all
    Project.destroy_all
  end

  def load
    set_language_if_valid(:es)
    Setting[:app_title]="TEO - Desarrollo"

    # Roles
    manager = Role.create! :name => l(:default_role_manager),
                                   :issues_visibility => 'all',
                                   :users_visibility => 'all',
                                   :position => 1
    manager.permissions = manager.setable_permissions.collect {|p| p.name}
    manager.save!
 
    # Issue statuses
    new          = IssueStatus.create!(:name => l(:default_issue_status_new), :is_closed => false, :position => 1)
    proposed     = IssueStatus.create!(:name => l(:teo_issue_status_proposed), :is_closed => false, :position => 2)
    in_progress  = IssueStatus.create!(:name => l(:default_issue_status_in_progress), :is_closed => false, :position => 3)
    feedback     = IssueStatus.create!(:name => l(:teo_issue_status_waiting), :is_closed => false, :position => 4)
    resolved     = IssueStatus.create!(:name => l(:default_issue_status_resolved), :is_closed => false, :position => 5)
    closed       = IssueStatus.create!(:name => l(:default_issue_status_closed), :is_closed => true, :position => 6)
    billed       = IssueStatus.create!(:name => l(:teo_issue_status_billed), :is_closed => true, :position => 6)
    rejected     = IssueStatus.create!(:name => l(:teo_issue_status_cancelled), :is_closed => true, :position => 6)

    # Trackers
    Tracker.create!(:name => l(:teo_tracker_task), :default_status_id => new.id, :is_in_chlog => true,  :is_in_roadmap => true,  :position => 2)

    # Workflow
    Tracker.all.each { |t|
      IssueStatus.all.each { |os|
        IssueStatus.all.each { |ns|
          WorkflowTransition.create!(:tracker_id => t.id, :role_id => manager.id, :old_status_id => os.id, :new_status_id => ns.id) unless os == ns
        }
      }
    }

    # Enumerations
    IssuePriority.create!(:name => l(:default_priority_low), :position => 1)
    IssuePriority.create!(:name => l(:default_priority_normal), :position => 2, :is_default => true)
    IssuePriority.create!(:name => l(:default_priority_high), :position => 3)
    IssuePriority.create!(:name => l(:default_priority_urgent), :position => 4)

    DocumentCategory.create!(:name => l(:default_doc_category_user), :position => 1)
    DocumentCategory.create!(:name => l(:teo_doc_category_project), :position => 2)
    DocumentCategory.create!(:name => l(:default_doc_category_tech), :position => 3)

    TimeEntryActivity.create!(:name => l(:teo_activity_base_hours), :position => 1)
    TimeEntryActivity.create!(:name => l(:teo_activity_project_manager), :position => 2)
    TimeEntryActivity.create!(:name => l(:teo_activity_functional_analyst), :position => 3)
    TimeEntryActivity.create!(:name => l(:teo_activity_programmer_analyst), :position => 4)
    TimeEntryActivity.create!(:name => l(:teo_activity_programmer), :position => 5)
    TimeEntryActivity.create!(:name => l(:teo_activity_senior_consultant), :position => 6)
    TimeEntryActivity.create!(:name => l(:teo_activity_consultant), :position => 7)
    TimeEntryActivity.create!(:name => l(:teo_activity_sysop), :position => 8)
    TimeEntryActivity.create!(:name => l(:teo_activity_sysop_analyst), :position => 9)
    TimeEntryActivity.create!(:name => l(:teo_activity_dba), :position => 10)
    TimeEntryActivity.create!(:name => l(:teo_activity_micro), :position => 11)
    TimeEntryActivity.create!(:name => l(:teo_activity_aux), :position => 12)

    # Auth sources
    AuthSourceLdap.create!(:name => "Corporativo", :host => "ldap23.juntadeandalucia.es", :port => 389, :base_dn => "o=empleados,o=juntadeandalucia,c=es", :attr_login => "uid", :attr_firstname => "givenName", :attr_lastname => "sn", :attr_mail => "mail", :onthefly_register => true, :tls => false)

    # Projects
    Project.create!(:name => "# NORMAS", :description => "", :identifier => "normas", :is_public => false, :inherit_members => false)
    Project.create!(:name => "# Soporte", :description => "", :identifier => "aprovisionamiento", :is_public => false, :inherit_members => false)
    Project.create!(:name => "1. DGPD", :description => "", :identifier => "dgpd", :is_public => false, :inherit_members => false)
    Project.create!(:name => "2. Sistemas de información", :description => "", :identifier => "si", :is_public => false, :inherit_members => false)
    Project.create!(:name => "3. Contratos", :description => "", :identifier => "contratos", :is_public => false, :inherit_members => false)
  end
end
