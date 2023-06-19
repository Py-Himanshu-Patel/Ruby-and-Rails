class ChangeTable < ActiveRecord::Migration[6.0]
  def change
    change_table :products do |t|
      # multiple columns name can pe put here
      t.remove :name
      # create a column of int type
      t.string :sale_location
      # put a index on this column
      t.index :part_number
      # rename column from to
      t.rename :description, :desc
    end
  end
end