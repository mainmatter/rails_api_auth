class AddProviderToLogin < ActiveRecord::Migration
  def change
    add_column :logins, :provider, :string
    rename_column :logins, :facebook_uid, :uid
  end
end
