desc "Update version number of all applications in automatic mode (called by the Heroku scheduler add-on)"
task :update_applications_version_number => :environment do
    puts "Date: #{Time.now}"
    puts "Updating applications version numbers..."
    IosApplication.update_all_applications_version_number
    puts "Done updating applications version numbers!"
end

desc "Update information of all applications using Apple API (called by the Heroku scheduler add-on)"
task :update_all_applications_information_from_apple => :environment do
    puts "Date: #{Time.now}"
    puts "Updating applications information..."
    IosApplication.update_all_applications_information_from_apple
    puts "Done updating applications information!"
end

