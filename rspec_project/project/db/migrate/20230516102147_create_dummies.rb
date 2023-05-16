class CreateDummies < ActiveRecord::Migration[7.0]
  def change
    create_table :dummies do |t|
      t.string :name
      t.integer :age
      t.datetime :dob

      t.timestamps
    end
  end
end
