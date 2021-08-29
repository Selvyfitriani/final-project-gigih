require './test_helper'
require './database/db_connector'
require './controllers/post_controller'
require './controllers/user_controller'
require './models/post'

describe PostController do
  before(:each) do
    client = create_db_client
    client.query('DELETE FROM users')
    client.query('DELETE FROM posts')
  end

  describe '#create' do
    context 'when given valid parameters' do
      it 'should save post to database and return successfully response' do
        user_controller = UserController.new
        user_params = {
          'id' => 1,
          'username' => 'selvyfitriani31',
          'email' => 'selvyfitriani31@gmail.com',
          'bio_description' => 'a learner'
        }
        user_controller.create(user_params)

        post_params = {
          'user_id' => user_params['id'],
          'text' => 'A new post',
          'datetime' => '2021-08-21 22:30:05'
        }
        post_controller = PostController.new
        response = post_controller.create(post_params)

        post_id = Post.last_insert_id
        post = Post.find_by_id(post_id)
        expect(post).not_to be nil

        expected_view = ERB.new(File.read('./views/success_create_post.erb')).result(binding)

        expect(response).to eq(expected_view)
      end
    end

    context 'when given non-existent user id' do
      it 'should not save to database and return error message in response' do
        params = {
          'user_id' => 1,
          'text' => 'A new post',
          'datetime' => '2021-08-21 22:30:05'
        }

        controller = PostController.new
        response = controller.create(params)

        post_id = Post.last_insert_id()
        expected_post = Post.find_by_id(post_id)
        expect(expected_post).to be nil

        expected_view = ERB.new(File.read('./views/failed_create_post.erb')).result(binding)

        expect(response).to eq(expected_view)
      end
    end
  end

  describe '#find_all_by_hashtag' do
    context 'when given hashtags' do
      it 'should return views that contain the related posts' do
        user = User.new('selvyfitriani31', 'selvyfitriani31@gmail.com', 'a learner', 1)
        user.save

        post = Post.new(user.id, 'I am a superhero #gigih #Semangat', '2021-08-21 22:30:05')
        post_num = 3
        1.upto(post_num) do
          post.save
        end

        params = { 'hashtag' => 'gigih' }
        posts = Post.find_all_by_hashtag(params['hashtag'])

        controller = PostController.new
        response = controller.find_all_by_hashtag(params)

        expected_view = ERB.new(File.read('./views/posts_by_hashtag.erb')).result(binding)
        expect(response).to eq(expected_view)
      end
    end
  end

  describe '#trending' do
    context 'when there are trending hashtag' do
      it 'should return views that contain the related post' do
        user = User.new('selvyfitriani31', 'selvyfitriani31@gmail.com', 'a learner', 1)
        user.save

        post = Post.new(user.id, 'I am a superhero #gigih #semangat', '2021-08-21 22:30:05')

        post_num = 3
        1.upto(post_num) do
          post.save
        end

        trending_hashtags = Post.trending
        controller = PostController.new
        response = controller.trending

        expected_view = ERB.new(File.read('./views/trending_hashtags.erb')).result(binding)

        expect(response).to eq(expected_view)
      end
    end
  end
end
