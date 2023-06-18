class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :occupation
      t.integer :max_login_attempts
      t.boolean :must_change_password

      t.timestamps
    end
  end
end
