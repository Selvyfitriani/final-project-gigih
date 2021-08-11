require "./test_helper"
require "./database/db_connector"
require './models/user'

describe User do
    describe '#valid?' do
        context 'when initialized with valid input' do
            it 'should return true' do
                user = User.new(
                    username = 'selvyfitriani31',
                    email = "selvyfitriani31@gmail.com",  
                    bio_description = 'a learner',
                )
                expect(user.valid?).to eq(true)
            end
        end

        context 'when initialized with invalid input' do
            it 'should return false' do
                user = User.new(
                    username = "",
                    email = "",
                    bio_description = "",
                )
                expect(user.valid?).to eq(false)
            end
        end

        context 'when initialized with invalid email' do
            it 'should return false' do
                user = User.new(
                    username = 'selvyfitriani31',
                    email = "@gmail.com",
                    bio_description = 'a learner',
                )
                expect(user.valid?).to eq(false)
            end
        end
    end

    describe '#save' do 
        context 'when initialized with valid input' do
            it 'should save to database' do
                user = User.new(
                    username = 'selvyfitriani31',
                    email = "selvyfitriani31@gmail.com",  
                    bio_description = 'a learner',
                )

                dummy_database = double
                allow(Mysql2::Client).to receive(:new).and_return(dummy_database)
                expect(dummy_database).to receive(:query).with("INSERT INTO " +
                    "users(username, email, bio_description) " + 
                    "VALUES('#{user.username}', '#{user.email}', '#{user.bio_description}')"
                )

                user.save
            end
        end
    end
end