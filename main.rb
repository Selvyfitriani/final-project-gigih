require 'sinatra'
require './controllers/user_controller'
require './controllers/post_controller'
require './controllers/comment_controller'

post '/users/create' do
  controller = UserController.new
  controller.create(params)
end

post '/posts/create' do
  controller = PostController.new
  controller.create(params)
end

get '/posts/trending' do
  controller = PostController.new
  controller.trending
end

get '/posts/:hashtag' do
  controller = PostController.new
  controller.get_all_by_hashtag(params)
end

post '/comments/create' do
  controller = CommentController.new
  controller.create(params)
end
