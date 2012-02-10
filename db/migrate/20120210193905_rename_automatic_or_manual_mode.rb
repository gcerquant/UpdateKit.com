class RenameAutomaticOrManualMode < ActiveRecord::Migration
  def change
    rename_column :ios_applications, :manual_version_management, :automatic_version_management
    
  end
end
