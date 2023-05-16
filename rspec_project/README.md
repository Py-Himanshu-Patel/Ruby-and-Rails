# Rspec and Factory Bot

## Rspec basic setup

- Write the `gem 'rspec-rails'` in Gemfile and hit `bundle install`. This will install Rspec for rails.
- Setup the rspec in rails with spec helper and rails helpers
```bash
$ rails generate rspec:install
      create  .rspec
      create  spec
      create  spec/spec_helper.rb
      create  spec/rails_helper.rb
```
- Create a model test for User class. In Rspec there are test for different objective like model, job, controller, mailer helper etc.
```bash
$ rails generate rspec:model User
      create  spec/models/user_spec.rb
```
- List all Rspec generator (See rspec repo for more : https://github.com/rspec/rspec-rails)
```bash
$ rails g --help | grep rspec
  rspec:channel
  rspec:controller
  rspec:feature
  rspec:generator
  rspec:helper
  rspec:install
  rspec:integration
  rspec:job
  rspec:mailbox
  rspec:mailer
  rspec:model
  rspec:request
  rspec:scaffold
  rspec:system
  rspec:view
```
- Running rspec
```bash
# Default: Run all spec files (i.e., those matching spec/**/*_spec.rb)
$ bundle exec rspec

# Run all spec files in a single directory (recursively)
$ bundle exec rspec spec/models

# Run a single spec file
$ bundle exec rspec spec/controllers/accounts_controller_spec.rb

# Run a single example from a spec file (by line number)
$ bundle exec rspec spec/controllers/accounts_controller_spec.rb:8

# See all options for running specs
$ bundle exec rspec --help
```
- Application behavior is described first in (almost) plain English, then again in test code, like so:
```ruby
RSpec.describe 'Post' do           #
  context 'before publication' do  # (almost) plain English
    it 'cannot have comments' do   #
      expect { Post.create.comments.create! }.to raise_error(ActiveRecord::RecordInvalid)  # test code
    end
  end
end
```
If it fails then it shows below kind of error
```
$ rspec --format documentation spec/models/post_spec.rb

Post
  before publication
    cannot have comments

Failures:

  1) Post before publication cannot have comments
     Failure/Error: expect { Post.create.comments.create! }.to raise_error(ActiveRecord::RecordInvalid)
       expected ActiveRecord::RecordInvalid but nothing was raised
     # ./spec/models/post.rb:4:in `block (3 levels) in <top (required)>'

Finished in 0.00527 seconds (files took 0.29657 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/models/post_spec.rb:3 # Post before publication cannot have comments
```
- Generate the model of User. (this also generate the spec file for model if not already)
```bash
$ rails generate model User name:string age:integer about:text
      invoke  active_record
      create    db/migrate/20230516084323_create_users.rb
      create    app/models/user.rb
      invoke    rspec
    conflict      spec/models/user_spec.rb
```
and apply migrations
```bash
$ rails db:migrate
== 20230516084323 CreateUsers: migrating ======================================
-- create_table(:users)
   -> 0.0015s
== 20230516084323 CreateUsers: migrated (0.0015s) =============================
```
To delete a model
```bash
$ rails d model User
```

- Run the spec test for user
```ruby
require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it "can run test" do
    expect(true).to be(false)
  end
end
```
```
$ rspec spec/models/user_spec.rb 
F

Failures:

  1) User can run test
     Failure/Error: expect(true).to be(false)
     
       expected false
            got true
```

## Factory Bot

- Write `gem 'factory_bot_rails'` in Gemfile and do `bundle install`
- Now generating model will also create factories for same and not just spec files.
```bash
$ rails g model Dummy
      invoke  active_record
      create    db/migrate/20230516095446_create_dummies.rb
      create    app/models/dummy.rb
      invoke    rspec
      create      spec/models/dummy_spec.rb
      invoke      factory_bot
      create        spec/factories/dummies.rb
```
Delete the model afterwards
```bash
$ rails d model Dummy
      invoke  active_record
      remove    db/migrate/20230516095446_create_dummies.rb
      remove    app/models/dummy.rb
      invoke    rspec
      remove      spec/models/dummy_spec.rb
      invoke      factory_bot
      remove        spec/factories/dummies.rb
```
- Check the factory file generated.
```bash
$ rails g model Dummy name:string age:integer dob:datetime
      invoke  active_record
      create    db/migrate/20230516102147_create_dummies.rb
      create    app/models/dummy.rb
      invoke    rspec
      create      spec/models/dummy_spec.rb
      invoke      factory_bot
      create        spec/factories/dummies.rb
```
```ruby
FactoryBot.define do
  factory :dummy do
    name { "MyString" }
    age { 1 }
    dob { "2023-05-16 15:51:47" }
  end
end
```
Here we the block return the expression inside them as value, whenever the factory is called.
```
f = FactoryBot.create(:dummy)
f.name == "MyString"
```
- Migrate the migrations of model we create above `rails db:migrate` and then tryout the FactoryBot in rails console. Also check the test database config in `database.yml`. This test db is erased all the times we run rake.
- Write some test in `dummy_spec.rb`
```ruby
require 'rails_helper'

RSpec.describe Dummy, type: :model do
  it "age must be less than 21" do
    # create actually create an dummy object and saves it to DB
    dummy = FactoryBot.create(:dummy)
    expect(dummy.age).to be < 21
  end

  it "must have an age greater than 21" do
    # create actually create an dummy object and saves it to DB
    dummy = FactoryBot.create(:dummy, age: 22)
    expect(dummy.age).to be > 21
  end
end
```
- Add a migration to dummy for email
```bash
rails g migrate add_email_to_dummy email:string
```
Tinker the migration a bit to have email as non null and default value for existing data.
```ruby
class AddEmailToDummy < ActiveRecord::Migration[7.0]
  def change
    add_column :dummies, :email, :string, null: false, default: "random@email.com"
    add_index :dummies, :email, unique: true
  end
end
```
- Update the email in factory
```ruby
FactoryBot.define do
  factory :dummy do
    name { "MyString" }
    age { 1 }
    dob { "2023-05-16 15:51:47" }
    email {"first@email.com"}
  end
end
```
