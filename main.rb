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
  controller.find_all_by_hashtag(params)
end

post '/comments/create' do
  controller = CommentController.new
  controller.create(params)
end

post '/attachment/create' do
  filename = params['attachment']['filename']
  tempfile = params['attachment']['tempfile']
  path = '/home/selvy/Documents/gigih/final-project-gigih/uploads'

  File.open(File.join(path, filename.to_s), 'wb') do |file|
    file.write(tempfile.read)
  end
end
