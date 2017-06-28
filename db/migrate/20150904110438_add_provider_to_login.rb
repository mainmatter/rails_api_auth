require_relative 'rails_api_auth_migration'

class AddProviderToLogin < RailsAPIAuthMigration

  def change
    add_column :logins, :provider, :string
    rename_column :logins, :facebook_uid, :uid
  end

end
