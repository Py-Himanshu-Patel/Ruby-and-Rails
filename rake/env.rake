task default: :environment

task :environment do
  puts "STUFF = #{ENV['STUFF']}"
end
