# Ruby and Rails

## List of Content
- [Rake](rake/README.md)
- [Rspec](rspec/README.md)
- [Active Records - Basic](active_record/basic/README.md)

---
## Make a new Rails App

- Make a new Rails App
```bash
# rails new app_name
rails new MyApp
```

- Setup DB - Update `database.yml` to below for postgres connection
```yml
# config/database.yml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000
  username: himanshu
  password: himanshu

development:
  <<: *default
  database: himanshu_dev

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<: *default
  database: himanshu_test

production:
  <<: *default
  database: himanshu_prod
```
- Also install the gem for pg `bundle add pg` and `bundle install`
- Create the db `rails db:create`. This will create the db's in psql
- Install `$ bundle add awesome_print` for better print in console.
