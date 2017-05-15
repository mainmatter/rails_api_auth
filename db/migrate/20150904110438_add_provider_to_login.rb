class AddProviderToLogin < ActiveRecord::Migration[4.2]

  def change
    add_column :logins, :provider, :string
    rename_column :logins, :facebook_uid, :uid
  end

end
