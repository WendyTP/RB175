# config.ru

# this is a 'rackup' file required for rack. It specifies what to run and how to run it.

require_relative 'app'
# it loads the app.rb file

run App.new
# a call to the 'run' method, which says what app we want to run on our server
# HelloWorld.new creates a class 'HelloWorld', which acts as our web application,
# and is where most of our application code will be