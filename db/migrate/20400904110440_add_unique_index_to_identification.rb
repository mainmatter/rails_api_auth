class AddUniqueIndexToIdentification < ActiveRecord::Migration

  def change
    add_index :logins, :identification, unique: true
  end

end
