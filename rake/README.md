# Rake

- To run `Rakefile` in a project
	```bash
	$ rake
	```
- To run Rakefile with any other name
	```bash
	$ rake -f mac_and_cheese.rake 
	```
- `:default` task is the entry point in Rakefile
	```rake
	task default: :mac_and_cheese	# preferred way of hash in ruby
	# OR
	task :default => :mac_and_cheese
	```
- Create dependencies in each task : [Example](mac_and_cheese.rake)
	```rake
	Going to store
	Buying Cheese
	Buying Pasta
	Boiling Water
	Mac and Cheese	
	```
- Rake load `Rakefile` and `rakelib/*.rake`
- Namesspace in rake: [Example](go_to_store.rake)
	```bash
	$ rake -f go_to_store.rake go_to_store
	Go to Store
	$ rake -f go_to_store.rake apple:go_to_store
	Going to the Apple Store
	```
- Action in rake run from root level / project level directory regardless of the location where we call rake. Also when `rake` is called it goes recursively up until it finds the Rakefile
	```bash
	Ruby-and-Rails/rake/# rake
	Default Task
	# change the location and run the rake again - this only catch Rakefile not other files named .rake
	Ruby-and-Rails/rake/first/second# rake
	(in /root/Ruby-and-Rails/rake)
	Default Task
	```
- `-P` Display the tasks and dependencies, then exit.
  ```bash
  $ rake -P -f mac_and_cheese.rake 
  rake boil_water
      buy_cheese
      buy_pasta
  rake buy_cheese
      go_to_store
  rake buy_pasta
      go_to_store
  rake default
      mac_and_cheese
  rake go_to_store
  rake mac_and_cheese
      boil_water
      buy_pasta
      buy_cheese
  ```
- `-T` Display the tasks (matching optional PATTERN) with descriptions, then exit.  
  ```bash
  $ rake -T -f mac_and_cheese.rake 
  rake boil_water      # Boil Water
  rake buy_cheese      # Buy Cheese
  rake buy_pasta       # Buy Pasta
  rake mac_and_cheese  # Make Mac & Cheese
   ```
  Get all **buy** task
  ```bash
  $ rake -f mac_and_cheese.rake -T buy
  rake buy_cheese  # Buy Cheese
  rake buy_pasta   # Buy Pasta
  ```
- `-W` Describe the tasks (matching optional PATTERN), then exit
  ```bash
  $ rake -f mac_and_cheese.rake -W boil
  rake boil_water                     /root/Ruby-and-Rails/rake/mac_and_cheese.rake:19:in `<top (required)>'
  ```
- Accessing Env Variables in Rakefile and passing variables on Command Line.
  ```bash
  # rake handles env var
  $ rake -f env.rake STUFF=PROD
  STUFF = PROD
  # shell handles env var
  $ STUFF=DEV rake -f env.rake 
  STUFF = DEV
  ```
- Rake support standard bash command line functions also like `ls`, `cp` etc.
- Rake tasks with arguments: [Example](cli_argument.rake)
  ```bash
  $ rake -f cli_argument.rake my_task[1,false]
  Args were: #<Rake::TaskArguments arg1: 1, arg2: false> of class Rake::TaskArguments
  arg1 was: '1' of class String
  arg2 was: 'false' of class String

  # OR - in case we want to use space in args then put them under ""

  $ rake -f cli_argument.rake "my_task[1, 2]"
  Args were: #<Rake::TaskArguments arg1: 1, arg2: 2> of class Rake::TaskArguments
  arg1 was: '1' of class String
  arg2 was: '2' of class String
  ```
  Invoking other tasks which pass arguments to prev task
  ```bash
  $ ake -f cli_argument.rake invoke_my_task_first
  Args were: #<Rake::TaskArguments arg1: 1, arg2: 2> of class Rake::TaskArguments
  arg1 was: '1' of class String
  arg2 was: '2' of class String
  
  # OR
  $ rake -f cli_argument.rake invoke_my_task_second
  Args were: #<Rake::TaskArguments arg1: 3, arg2: 4> of class Rake::TaskArguments
  arg1 was: '3' of class Integer
  arg2 was: '4' of class Integer
  ```
  Invoking a task with prerequisite task as the one which takes arguments, then the args will be forwarded to that task
  ```bash
  rake -f cli_argument.rake with_prerequisite[5,6]
  Args were: #<Rake::TaskArguments arg1: 5, arg2: 6> of class Rake::TaskArguments
  arg1 was: '5' of class String
  arg2 was: '6' of class String
  ```
  We can also pass default parameters
  ```bash
  $ rake -f cli_argument.rake with_defaults
  Args with defaults were: #<Rake::TaskArguments arg1: default_1, arg2: default_2>

  # OR - remember not to put spaces in args 

  rake -f cli_argument.rake with_defaults[1,2]
  Args with defaults were: #<Rake::TaskArguments arg1: 1, arg2: 2>
  ```
- If running the task from Rails, it's best to preload the environment by adding `=> [:environment]` which is a way to setup dependent tasks.
  ```bash
  task :work, [:option, :foo, :bar] => [:environment] do |task, args|
    puts "work", args
  end
  ```