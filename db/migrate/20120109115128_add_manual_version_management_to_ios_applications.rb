class AddManualVersionManagementToIosApplications < ActiveRecord::Migration
  def change
    add_column :ios_applications, :manual_version_management, :boolean
  end
end
