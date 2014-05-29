desc "Run karma test runner for JavaScript tests"
task :karma do
  cmd = "karma start jstest/config.coffee"
  system(cmd)
   raise "#{cmd} failed!" unless $?.exitstatus == 0
end
