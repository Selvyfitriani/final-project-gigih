require './test_helper'
require './database/db_connector'
require './controllers/user_controller'
require './controllers/post_controller'
require './controllers/comment_controller'

describe CommentController do
  before(:each) do
    client = create_db_client
    client.query('DELETE FROM users')
    client.query('DELETE FROM posts')
    client.query('DELETE FROM comments')
  end

  describe '#create' do
    context 'when given valid parameters' do
      it 'should save to database and return success response' do
        user_controller = UserController.new
        user_params = {
          'id' => 1,
          'username' => 'selvyfitriani31',
          'email' => 'selvyfitriani31@gmail.com',
          'bio_description' => 'a learner'
        }
        user_controller.create(user_params)

        post_params = {
          'id' => 1,
          'user_id' => user_params['id'],
          'text' => 'A new post',
          'datetime' => '2021-08-21 22:30:05'
        }
        post_controller = PostController.new
        post_controller.create(post_params)

        comment_params = {
          'user_id' => user_params['id'],
          'post_id' => post_params['id'],
          'text' => 'A new comment'
        }
        comment_controller = CommentController.new
        response = comment_controller.create(comment_params)

        comment_id = Comment.last_insert_id
        comment = Comment.find_by_id(comment_id)
        expect(comment).not_to be nil

        expected_view = ERB.new(File.read('./views/success_create_comment.erb')).result(binding)

        expect(response).to eq(expected_view)
      end
    end

    context 'when given non-existent user id and post id' do
      it 'should not save to database and return error message in response' do
        comment_params = {
          'user_id' => 1,
          'post_id' => 1,
          'text' => 'A new comment'
        }

        comment_controller = CommentController.new
        response = comment_controller.create(comment_params)

        comment_id = Comment.last_insert_id
        comment = Comment.find_by_id(comment_id)
        expect(comment).to be nil

        expected_view = ERB.new(File.read('./views/failed_create_comment.erb')).result(binding)
        expect(response).to eq(expected_view)
      end
    end
  end
end
