require 'sinatra'
require './controllers/user_controller'
require './controllers/post_controller'

post '/users/create' do
    controller = UserController.new
    controller.create(params)
end

post '/posts/create' do
    controller = PostController.new
    controller.create(params)
end