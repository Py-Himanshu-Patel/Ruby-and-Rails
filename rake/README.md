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
