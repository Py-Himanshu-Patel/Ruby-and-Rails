class CreateTable < ActiveRecord::Migration[6.0]
  def change
    create_table :MyTable do |t|
      t.string :firstname
      t.string :lastname
    end
  end
end
