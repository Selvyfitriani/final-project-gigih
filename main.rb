require 'sinatra'
require './controllers/user_controller'

post '/users/create' do
    controller = UserController.new
    controller.create(params)
end