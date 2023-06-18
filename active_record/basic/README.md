# Active Record - Basic

- Rails will pluralize your class names to find the respective database table. So, for a class Book, you should have a database table called books.
- **Model Class** - Singular with the first letter of each word capitalized (e.g., BookClub).
  **Database Table** - Plural with underscores separating words (e.g., book_clubs).
- Sample Model to table name
Model Class -> Table/Schema
  - Article > articles
  - LineItem > line_items
  - Deer > deers
  - Mouse > mice 
  - Person > people
- **Foreign keys** - These fields should be named following the pattern `singularized_table_name_id` (e.g., item_id, order_id). These are the fields that Active Record will look for when you create associations between your models.
- **Primary keys** - By default, Active Record will use an integer column named id as the table's primary key (bigint for PostgreSQL and MySQL, integer for SQLite). When using Active Record Migrations to create your tables, this column will be automatically created.

### Overriding the Naming Conventions
- Specify the table name in the Model Class
```ruby
class Product < ApplicationRecord
  self.table_name = "my_products"
end
```
If you do so, you will have to define manually the class name that is hosting the fixtures (`my_products.yml`) using the set_fixture_class method in your test definition:
```ruby
class ProductTest < ActiveSupport::TestCase
set_fixture_class my_products: Product
fixtures :my_products
# ...
end
```


## CRUD
Use below command to setup Model Class
```bash
$ rails g model User name:string occupation:string max_login_attempts:integer must_change_password:boolean
Running via Spring preloader in process 753678
      invoke  active_record
      create    db/migrate/20230618142459_create_users.rb
      create    app/models/user.rb
      invoke    test_unit
      create      test/models/user_test.rb
      create      test/fixtures/users.yml
```
```bash
$ rails db:migrate
```

### Create
```ruby
# save and return object
user = User.create(name: "David", occupation: "Code Artist")
```
```ruby
# just return object and saving is explicit
user = User.new
user.name = "David"
user.occupation = "Code Artist"
# to commit call
user.save
```
This is same as
```ruby
user = User.new do |u|
  u.name = "David"
  u.occupation = "Code Artist"
end
```
### Read
```ruby
# return a collection with all users
users = User.all
# return the first user
user = User.first
# return the first user named David
david = User.find_by(name: 'David')
# find all users named David who are Code Artists and 
# sort by created_at in reverse chronological order
users = User.where(
        name: 'David', 
        occupation: 'Code Artist').order(created_at: :desc)
```
### Update
```ruby
user = User.find_by(name: 'David')
user.name = 'Dave'
user.save
# same as 
user = User.find_by(name: 'David')
user.update(name: 'Dave')
```
To update all the records
```ruby
User.update_all "max_login_attempts = 3, must_change_password = 'true'"
# OR
User.update_all(max_login_attempts: 5)
# OR
User.update(:all, max_login_attempts: 3, must_change_password: true)
```
### Delete
```ruby
user = User.find_by(name: 'David')
user.destroy
# find and delete all users named David
User.destroy_by(name: 'David')
# delete all users
User.destroy_all
```

## Validations
Validation is a very important issue to consider when persisting to the 
database, so the methods `save` and `update` take it into account when
running: they return false when validation fails and they don't actually 
perform any operations on the database. All of these have a bang 
counterpart (that is, `save!` and `update!`), which are stricter in 
that they raise the exception `ActiveRecord::RecordInvalid` if validation fails.

```ruby
class User < ApplicationRecord
  validates :name, presence: true
end
```
```ruby
user = User.new
user.save
=> false
user.save!
=> ActiveRecord::RecordInvalid: Validation failed: Name can't be blank
```
