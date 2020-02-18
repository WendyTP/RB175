require 'tilt/erubis'
require 'sinatra'
require 'sinatra/reloader'
require 'yaml'

before do
  @users_data = YAML.load_file("users.yaml")
end

helpers do
  
  def count_interests(user_data)
    sum = 0
    user_data.each do |name, data|
      sum += data[:interests].size
    end
    sum
  end
end

get "/" do
  redirect "/users"
end

get "/users" do
  erb(:users)
end

get "/:user_name" do
  @user_name = params[:user_name].to_sym
  @email = @users_data[@user_name][:email]
  @interests = @users_data[@user_name][:interests]

  erb(:user)
end