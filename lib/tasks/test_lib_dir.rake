namespace :test do

  desc "Test lib source"
  Rake::TestTask.new(:lib) do |t|    
    t.libs << "test"
    t.pattern = 'spec/lib/**/*_spec.rb'
    t.verbose = true    
  end

end
