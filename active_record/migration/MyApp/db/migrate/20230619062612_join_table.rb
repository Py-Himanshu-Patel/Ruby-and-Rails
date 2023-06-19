class JoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :products, :categories
  end
end
