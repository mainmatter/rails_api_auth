class AddUniqueIndexToIdentification < ActiveRecord::Migration

  def change
    remove_index :logins, :index_logins_on_identification
    add_index :logins, :index_logins_on_identification, using: :btree
  end

end
