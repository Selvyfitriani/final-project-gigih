require './test_helper'
require './database/db_connector'
require './models/user'

describe User do 
  before(:each) do
    client = create_db_client
    client.query('DELETE FROM users')
  end

  describe '#valid?' do
    context 'when initialized with valid attributes value' do
      it 'should return true' do
        user = User.new('selvyfitriani31', 'selvyfitriani31@gmail.com', 'a learner')
        expect(user.valid?).to eq(true)
      end
    end

    context 'when initialized with invalid attributes value' do
      it 'should return false' do
        user = User.new('', '', '')
        expect(user.valid?).to eq(false)
      end
    end

    context 'when initialized with invalid email' do
      it 'should return false' do
        user = User.new('selvyfitriani31', '@gmail.com', 'a learner')
        expect(user.valid?).to eq(false)
      end
    end
  end

  describe '#save' do
    context 'when initialized with valid attributes value' do
      it 'should save to database' do
        user = User.new('selvyfitriani31', 'selvyfitriani31@gmail.com', 'a learner')
        dummy_database = double
        allow(Mysql2::Client).to receive(:new).and_return(dummy_database)
        expect(dummy_database).to receive(:query).with("INSERT INTO users(username, email, bio_description)
          VALUES('#{user.username}', '#{user.email}', '#{user.bio_description}')")

        user.save
      end
    end

    context 'when initialized with invalid attributes value' do
      it 'should return false' do
        user = User.new('', '@gmail.com', '')

        expect(user.save).to eq(false)
      end
    end

    context 'when initialized with too long parameters value' do
      it 'should return false' do
        user = User.new('its_more_than_30_characters_____',
                        'this_email_is_more_than_40_characters_@gmail.com',
                        'bio desc must less than 150')

        expect(user.save).to eq(false)
      end
    end
  end
end
