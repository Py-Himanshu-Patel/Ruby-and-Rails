task default: :mac_and_cheese

desc 'Make Mac & Cheese'
task mac_and_cheese: %I[boil_water buy_pasta buy_cheese] do
  puts 'Mac and Cheese'
end

desc 'Buy Cheese'
task buy_cheese: :go_to_store do
  puts 'Buying Cheese'
end

desc 'Buy Pasta'
task buy_pasta: :go_to_store do
  puts 'Buying Pasta'
end

desc 'Boil Water'
task boil_water: %I[buy_cheese buy_pasta] do
  puts 'Boiling Water'
end

task :go_to_store do
  puts 'Going to store'
end
