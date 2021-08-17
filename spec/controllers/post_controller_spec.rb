require "./controllers/post_controller"
require "./controllers/user_controller"
require "./models/post"

describe PostController do
    before (:each) do
        client = create_db_client
        client.query("DELETE FROM users")
        client.query("DELETE FROM posts")
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
             
                params = {
                    "user_id" => user_params["id"],
                    "text" => "A new post",
                    "datetime" => "2021-08-21 22:30:05"   
                }

                controller = PostController.new
                response = controller.create(params)

                post_id = Post.get_last_insert_id()
                expected_post = Post.find_by_id(post_id)
                expect(expected_post).not_to be nil

                expected_response = JSON.generate({"status_code" => "201", "message" => "Successfully insert post to database"})
                expect(response).to eq(expected_response)

            end
        end
    end
end