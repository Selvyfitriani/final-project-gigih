require './test_helper'
require './database/db_connector'
require './controllers/user_controller'

describe UserController do
  describe '#create' do
    before(:each) do
      client = create_db_client
      client.query('DELETE FROM users')
    end

    context 'when given valid parameters' do
      it 'should save user and return successfully response' do
        params = {
          'username' => 'selvyfitriani31',
          'email' => 'selvyfitriani31@gmail.com',
          'bio_description' => 'a learner'
        }

        controller = UserController.new

        response = controller.create(params)

        user_id = User.get_last_insert_id()
        expected_user = User.get_by_id(user_id)
        expect(expected_user).not_to be nil

        expected_response = JSON.generate(
          {
            'status_code' => '201',
            'message' => 'Successfully insert user to database'
          }
        )
        expect(response).to eq(expected_response)
      end
    end

    context 'when given invalid parameters' do
      it 'should not save user and return error message in response' do
        params = {
          'username' => '',
          'email' => '@gmail.com',
          'bio_description' => ''
        }

        controller = UserController.new
        response = controller.create(params)

        user_id = User.get_last_insert_id()
        expected_user = User.get_by_id(user_id)
        expect(expected_user).to be nil

        expected_response = JSON.generate(
          {
            'status_code' => '400',
            'message' => 'Sorry! Creating new user is failed because invalid parameters'
          }
        )
        expect(response).to eq(expected_response)
      end
    end
  end
end
