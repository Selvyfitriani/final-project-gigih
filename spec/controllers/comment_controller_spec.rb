require "./test_helper"
require "./database/db_connector"
require "./controllers/user_controller"
require "./controllers/post_controller"
require "./controllers/comment_controller"


describe CommentController do
    before(:each) do
        client = create_db_client
        client.query("DELETE FROM users")
        client.query("DELETE FROM posts")
        client.query("DELETE FROM comments")
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
                    "id" => 1,
                    "user_id" => user_params["id"],
                    "text" => "A new post",
                    "datetime" => "2021-08-21 22:30:05"   
                }
                post_controller = PostController.new
                post_controller.create(post_params)

                comment_params = {
                    "user_id" => user_params["id"],
                    "post_id" => post_params["id"],
                    "text" => "A new comment"
                }
                comment_controller = CommentController.new
                response = comment_controller.create(comment_params)

                comment_id = Comment.get_last_insert_id
                expected_comment = Comment.get_by_id(comment_id)
                expect(expected_comment).not_to be nil

                expected_response = JSON.generate({"status_code" => "201", "message" => "Successfully insert comment to database"})
                expect(response).to eq(expected_response)
            end
        end

        context 'when given non-existent user id and post id' do
            it 'should not save to database and return error message in response' do
                comment_params = {
                    "user_id" => 1,
                    "post_id" => 1,
                    "text" => "A new comment"
                }

                comment_controller = CommentController.new
                response = comment_controller.create(comment_params)

                comment_id = Comment.get_last_insert_id
                expected_comment = Comment.get_by_id(comment_id)
                expect(expected_comment).to be nil

                expected_response = JSON.generate({"status_code" => "400", "message" => "Sorry! Creating new comment is failed because invalid parameters"})
                expect(response).to eq(expected_response)
            end
        end
    end
end