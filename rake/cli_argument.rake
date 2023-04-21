task default: :my_task

task :my_task, [:arg1, :arg2] do |_t, args|
  puts "Args were: #{args} of class #{args.class}"
  puts "arg1 was: '#{args[:arg1]}' of class #{args[:arg1].class}"
  puts "arg2 was: '#{args[:arg2]}' of class #{args[:arg2].class}"
end

# invoke another task and provide arguments
task :invoke_my_task_first do
  Rake.application.invoke_task('my_task[1, 2]')
end

# Same as above, invoke another task and provide arguments
task :invoke_my_task_second do
  Rake::Task[:my_task].invoke(3, 4)
end

# a task with prerequisites passes its arguments to it prerequisites task
task :with_prerequisite, [:arg1, :arg2] => :my_task # <- name of prerequisite task

# to specify default values we take advantage of args being a
# Rake::TaskArguments object
task :with_defaults, [:arg1, :arg2] do |_t, args|
  args.with_defaults(:arg1 => :default_1, :arg2 => :default_2)
  puts "Args with defaults were: #{args}"
end
