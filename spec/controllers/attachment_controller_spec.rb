require './controllers/attachment_controller'
require './controllers/user_controller'
require './controllers/post_controller'
require './database/db_connector'

describe AttachmentController do
  before(:each) do
    client = create_db_client
    client.query('DELETE FROM users')
    client.query('DELETE FROM posts')
    client.query('DELETE FROM comments')
  end

  describe '#create' do
    context 'when given valid parameters for attachment post' do
      it 'should save to database and return success json' do
        user_controller = UserController.new
        user_params = {
          'id' => 1,
          'username' => 'selvyfitriani31',
          'email' => 'selvyfitriani31@gmail.com',
          'bio_description' => 'a learner'
        }
        user_controller.create(user_params)

        params = {
          'id' => 1,
          'user_id' => user_params['id'],
          'text' => 'A new post',
          'datetime' => '2021-08-21 22:30:05',
          'attachment' => {
            'filename' => 'filename.png',
            'type' => 'image/png'
          }
        }

        post_controller = PostController.new
        post_controller.create(params)

        attachment_controller = AttachmentController.new
        attachment_controller.create(params)
      end
    end

    context 'when given valid parameters for attachment comment' do
      it 'should save to database and return success json' do
        user_params = {
          'id' => 1,
          'username' => 'selvyfitriani31',
          'email' => 'selvyfitriani31@gmail.com',
          'bio_description' => 'a learner'
        }
        user_controller = UserController.new
        user_controller.create(user_params)

        post_params = {
          'id' => 1,
          'user_id' => user_params['id'],
          'text' => 'A new post',
          'datetime' => '2021-08-21 22:30:05'
        }
        post_controller = PostController.new
        post_controller.create(post_params)

        params = {
          'id' => 1,
          'user_id' => user_params['id'],
          'post_id' => post_params['id'],
          'text' => 'A new comment',
          'attachment' => {
            'filename' => 'filename.png',
            'type' => 'image/png'
          }
        }
        comment_controller = CommentController.new
        comment_controller.create(params)

        attachment_controller = AttachmentController.new
        attachment_controller.create(params)
      end
    end
  end
end
