# Migration

- Migrations are a convenient way to alter your database schema over time in a consistent way. 
They use a Ruby DSL so that you don't have to write SQL by hand, allowing your schema and changes 
to be database independent.

- Migrations are stored as files in the db/migrate directory, one for each migration class. 
The name of the file is of the form `YYYYMMDDHHMMSS_create_products.rb`, that is to say a UTC timestamp 
identifying the migration followed by an underscore followed by the name of the migration.

An example of migration
```ruby
class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
```

Generate a `Product` table inorder to start
```shell
rails generate model Product name:string description:text
```
```ruby
  # schema.rb
  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end
```

### Generate Basic Migration
Command to generate migration
```shell
$ bin/rails generate migration AddPartNumberToProducts
```
Migration file
```ruby
class AddPartNumberToProducts < ActiveRecord::Migration[7.0]
  def change
  end
end
```

### Add/Remove columns
If the migration name is of the form `AddColumnToTable` or `RemoveColumnFromTable` 
and is followed by a list of column names and types then a migration containing 
the appropriate `add_column` and `remove_column` statements will be created.

```shell
bin/rails generate migration AddPartNumberToProducts part_number:string
```
Generate migration
```ruby
class AddPartNumberToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :part_number, :string
  end
end
```
after `rails db:migrate` the updated `schema.rb` looks like
```ruby
  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "part_number"
  end
```
Similarly to remove the column from a table `RemoveColumnFromTable`
```shell
$ bin/rails generate migration RemovePartNumberFromProducts part_number:string
```
```ruby
class RemovePartNumberFromProducts < ActiveRecord::Migration[7.0]
  def change
    remove_column :products, :part_number, :string
  end
end
```
Generate/Delete more than one column as
```shell
$ bin/rails generate migration CreateProducts name:string part_number:string
```

### Create custom migration
As always, what has been generated for you is just a starting point. You can add or remove from it 
as you see fit by editing the `db/migrate/YYYYMMDDHHMMSS_add_details_to_products.rb file`.

It means you can create a blank migration file (to get correct ordering as per time stamp) and then use that migration
to do any sort of create_table, remove or add column.

### Generate references
```shell
bin/rails generate migration AddUserRefToProducts user:references
```
```ruby
class AddUserRefToProducts < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :user, null: false, foreign_key: true
  end
end
```
This migration will create a `user_id` column on `Product` table. this migration consider the products
in Product table do not have null value for `user_id` column else there will be an error. Check `schema.rb`
after migration.

### Create Join table
```shell
bin/rails generate migration CreateJoinTableCustomerProduct customer product
```

```ruby
class CreateJoinTableCustomerProduct < ActiveRecord::Migration[7.0]
  def change
    create_join_table :customers, :products do |t|
      # t.index [:customer_id, :product_id]
      # t.index [:product_id, :customer_id]
    end
  end
end
```
`schema.rb` file
```ruby
  create_table "customers_products", id: false, force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "product_id", null: false
  end
```
    
### Model Generators
### Passing Modifiers
