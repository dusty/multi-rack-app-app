namespace :vendor do
  
  desc "Print all vendor names"
  task :names => :init do
    Vendor::NAMES.each {|name| puts name}
  end
  
end