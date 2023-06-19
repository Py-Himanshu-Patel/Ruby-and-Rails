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

### List Migrations
```shell
rails db:migrate:status

 Status   Migration ID    Migration Name
--------------------------------------------------
   up     20230618142459  Create users
   up     20230618183918  Create products
   up     20230618184613  Add part number to products
   up     20230618191651  Add user ref to products
   up     20230618193901  Create join table customer product
   up     20230619030152  Create table
  down    20230619052200  Join table
  down    20230619052428  Create categories
```
- Perform a `rake db:migrate VERSION=XXX` on all environments, to the version before the one I want to delete. Status will become `down` for these migrations.
- Delete the migration file manually.
- If there are pending migrations (i.e., the migration I removed was not the last one), I just perform a new rake db:migrate again.

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
The model, resource, and scaffold generators will create migrations appropriate for adding a new model. 
This migration will already contain instructions for creating the relevant table. If you tell Rails what 
columns you want, then statements for adding these columns will also be created.

```shell
bin/rails generate model Product name:string description:text
```
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
    
### Passing Modifiers
```shell
bin/rails generate migration AddDetailsToProducts 'price:decimal{5,2}' supplier:references{polymorphic}
```
```ruby
class AddDetailsToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :price, :decimal, precision: 5, scale: 2
    add_reference :products, :supplier, polymorphic: true
  end
end
```

## Writing a Migration

### Creating a Table
Create a blank migration and write it as per per need
```shell
rails g migration CreateTable
```
```ruby
class CreateTable < ActiveRecord::Migration[6.0]
  def change
    create_table :tables do |t|
    end
  end
end
```

Write code to actually create a table, (Here I did the mistake but create table name with plural name
not singular, that too snake cased not camel case).
```ruby
class CreateTable < ActiveRecord::Migration[6.0]
  def change
    create_table :MyTable do |t|
      t.string :firstname
      t.string :lastname
    end
  end
end
```
Apply the migration and check the DB
```shell
rails db:migrate
```
```shell
MyAppDev=# \dt
                List of relations
 Schema |         Name         | Type  |  Owner   
--------+----------------------+-------+----------
 public | MyTable              | table | himanshu
 public | ar_internal_metadata | table | himanshu
 public | customers_products   | table | himanshu
 public | products             | table | himanshu
 public | schema_migrations    | table | himanshu
 public | users                | table | himanshu
(6 rows)
```

# Create a Join Table
The migration method `create_join_table` creates an `HABTM` (has and belongs to many) join table. 
A typical use would be:
```shell
rails generate model Category name:string quantity:integer
rails db:migrate
rails generate migration JoinTable
```
```ruby
class JoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :products, :categories
  end
end
```
This creates a table `categories_products` in DB table are appended
in alphabetical sort order.

To customize the name of the table, provide a `:table_name option:`
This will creates a `categorization` table.
```ruby
create_join_table :products, :categories, table_name: :categorization
```

`create_join_table` also accepts a block, which you can use to add indices 
(which are not created by default) or additional columns:
```shell
create_join_table :products, :categories do |t|
  t.index :product_id
  t.index :category_id
end
```

### Changing Table
```shell
rails generate migration change_table
```
Make sure to put the exact name of table as appear in DB
in front of `change_table` statement.
```ruby
class ChangeTable < ActiveRecord::Migration[6.0]
  def change
    change_table :products do |t|
      # multiple columns name can pe put here
      t.remove :name
      # create a column of string type
      t.string :sale_location
      # put a index on this column
      t.index :part_number
      # rename column from to
      t.rename :description, :desc
    end
  end
end
```

### Changing Columns
