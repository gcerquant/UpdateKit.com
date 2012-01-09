class AddUserIdToIosApplications < ActiveRecord::Migration
  def change
    add_column :ios_applications, :user_id, :integer
  end
end
