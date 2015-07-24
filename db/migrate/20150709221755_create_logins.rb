class CreateLogins < ActiveRecord::Migration

  def change
    create_table :logins do |t|
      t.string :email,           null: false
      t.string :password_digest, null: true
      t.string :oauth2_token,    null: false
      t.string :facebook_uid
      t.string :single_use_oauth2_token

      t.references :user

      t.timestamps
    end
  end

end
