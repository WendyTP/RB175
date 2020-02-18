require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"
require "yaml"

before do
  @users_info = YAML.load_file("users.yaml")  
end

helpers do
  def count_interests(users_info)
    users_info.inject(0) do |sum, (name, user)|
      sum + user[:interests].size
    end
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
  @email = @users_info[@user_name][:email]
  @interests = @users_info[@user_name][:interests]

  erb(:user)
end