require "./test_helper"
require './models/user'

describe User do
    describe '#valid?' do
        context 'when initialized with valid input' do
            it 'should return true' do
                user = User.new(
                    username = 'selvyfitriani31',
                    email = 'selvyfitriani31@gmail.com',
                    bio_description = 'a learner',
                )
                expect(user.valid?).to eq(true)
            end
        end
    end
end