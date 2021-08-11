require "./test_helper"
require "./database/db_connector"
require "./controllers/user_controller"

describe UserController do
    describe '#create' do

        before(:each) do 
            client = create_db_client
            client.query("DELETE FROM users")
        end

        context 'when given valid parameters' do
            it 'should save user' do
                params = {
                    'username' => 'selvyfitriani31',
                    'email' => 'selvyfitriani31@gmail.com',
                    'bio_description' => 'a learner'
                }

                controller = UserController.new

                controller.create(params)

                user_id = User.get_last_insert_id()
                expected_user = User.find_by_id(user_id)
                expect(expected_user).not_to be nil
            end
        end
    end
end