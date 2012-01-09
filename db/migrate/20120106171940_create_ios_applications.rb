class CreateIosApplications < ActiveRecord::Migration
  def change
    create_table :ios_applications do |t|
      t.string :title
      t.string :application_bundle_identifier
      t.string :apple_identifier
      t.string :published_version_number
      t.string :custom_published_url

      t.timestamps
    end
  end
end
