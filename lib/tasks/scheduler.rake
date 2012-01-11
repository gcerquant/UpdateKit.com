desc "Update version number of all applications in automatic mode (called by the Heroku scheduler add-on)"
task :update_applications_version_number => :environment do
    puts "Date: #{Time.now}"
    puts "Updating applications version numbers..."
    IosApplication.update_all_applications_version_number
    puts "Done update applications version numbers!"
end

