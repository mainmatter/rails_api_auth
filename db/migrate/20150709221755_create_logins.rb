class CreateLogins < ActiveRecord::Migration

  def change
    primary_key_chooser = lambda do |key|
      RailsApiAuth.primary_key_type ? { key => RailsApiAuth.primary_key_type } : {}
    end
    create_table :logins, primary_key_chooser.call(:id) do |t|
      t.string :identification,  null: false
      t.string :password_digest, null: true
      t.string :oauth2_token,    null: false
      t.string :facebook_uid
      t.string :single_use_oauth2_token

      t.references :user, primary_key_chooser.call(:type)

      t.timestamps
    end
  end

end
