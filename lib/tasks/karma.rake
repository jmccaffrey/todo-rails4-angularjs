desc "Run karma test runner for JavaScript tests"
task :karma do
  cmd = "node_modules/karma/bin/karma start jstest/config.coffee"
  puts system(cmd)
   raise "#{cmd} failed!" unless $?.exitstatus == 0
end
