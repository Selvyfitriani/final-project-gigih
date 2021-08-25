require './database/db_connector'
require './models/attachment'
require './models/user'
require './models/post'

describe Attachment do
  describe '#valid?' do
    context 'when given valid input' do
      it 'should return true' do
        attachment = Attachment.new('filename.png', 'image/png', 1)

        expect(attachment.valid?).to eq(true)
      end
    end

    context 'when given post and comment id simultaneously' do
      it 'should return false' do
        attachment = Attachment.new('filename.png', 'image/png', 1, 1)

        expect(attachment.valid?).to eq(false)
      end
    end
  end

  describe '#save' do
    before(:each) do
      client = create_db_client
      client.query('DELETE FROM users')
      client.query('DELETE FROM posts')
    end

    context 'when given valid  attachment for a post' do
      it 'should save to database and return true' do
        user = User.new('selvyfitriani31', 'selvyfitriani31@gmail.com', 'a learner', 1)
        user.save

        post = Post.new(user.id, 'A new post', '2021-08-21 22:30:05', 1)
        post.save

        attachment = Attachment.new('filename.png', 'image/png', post.id)

        dummy_database = double
        allow(Mysql2::Client).to receive(:new).and_return(dummy_database)
        allow(dummy_database).to receive(:query).with("INSERT INTO attachment(filename, type, post_id)
          VALUES('#{attachment.filename}', '#{attachment.type}', #{attachment.post_id}")

        response = attachment.save

        expect(response).to eq(true)
      end
    end
  end
end
