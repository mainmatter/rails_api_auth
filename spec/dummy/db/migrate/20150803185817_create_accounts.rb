class CreateAccounts < ActiveRecord::Migration

  def change
    create_table :accounts do |t|
      t.string :first_name, null: false
      t.string :last_name,  null: true

      t.timestamps
    end
  end

end
