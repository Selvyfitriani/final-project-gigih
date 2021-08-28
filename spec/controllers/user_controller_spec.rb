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
        user_id = User.last_insert_id
        user = User.find_by_id(user_id)
        expect(user).not_to be nil

        expected_view = ERB.new(File.read('./views/success_create_user.erb')).result(binding)
        expect(response).to eq(expected_view)
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

        user_id = User.last_insert_id
        expected_user = User.find_by_id(user_id)
        expect(expected_user).to be nil

        expected_view = ERB.new(File.read('./views/failed_create_user.erb')).result(binding)
        expect(response).to eq(expected_view)
      end
    end
  end
end
