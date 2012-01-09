# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run UpdateKitCom::Application


$stdout.sync = true #  disable buffering to take advantage of Heroku’s realtime logging