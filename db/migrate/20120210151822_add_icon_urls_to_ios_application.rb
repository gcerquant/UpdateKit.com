class AddIconUrlsToIosApplication < ActiveRecord::Migration
  def change
    add_column :ios_applications, :icon_small_url, :string
    add_column :ios_applications, :icon_url, :string
  end
end
