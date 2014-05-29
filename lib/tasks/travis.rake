namespace :travis do
 
  desc "Prepare DB and run Tests"
  task :run do
    ["db:create", "db:migrate RAILS_ENV=test", "spec RAILS_ENV=test", "karma"].each do |cmd|
      puts "Starting to run #{cmd}..."
      system("bundle exec rake #{cmd}")
      raise "#{cmd} failed!" unless $?.exitstatus == 0
    end
  end
 
end