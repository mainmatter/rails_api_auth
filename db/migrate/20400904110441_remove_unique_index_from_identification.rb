class RemoveUniqueIndexFromIdentification < ActiveRecord::Migration

  def change
    remove_index :logins, :identification
    add_index :logins, :identification
  end

end
