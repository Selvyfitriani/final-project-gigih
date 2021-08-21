require "./test_helper"
require "./database/db_connector"
require "./models/comment"

describe Comment do
    before(:each) do
        client = create_db_client
        client.query("DELETE FROM users")
        client.query("DELETE FROM posts")
        client.query("DELETE FROM comments")
    end

    describe '#valid?' do
        context 'when given valid attributes value' do
            it 'should return true' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = "selvyfitriani31@gmail.com",  
                    bio_description = 'a learner',
                )
                user.save
                
                post = Post.new(
                    id = 1,
                    user_id = user.id,
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05"
                )
                post.save

                comment = Comment.new(
                    user_id = user.id,
                    post_id = post.id,
                    text = "A new comment"  
                )

                expect(comment.valid?).to eq(true)
            end
        end

        context 'when given user id with alphabetical form' do
            it 'should return false' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = "selvyfitriani31@gmail.com",  
                    bio_description = 'a learner',
                )
                user.save
                
                post = Post.new(
                    id = 1,
                    user_id = user.id,
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05"
                )
                post.save

                comment = Comment.new(
                    user_id = "a",
                    post_id = post.id,
                    text = "A new comment"  
                )

                expect(comment.valid?).to eq(false)
            end
        end

        context 'when given post id with alphabetical form' do
            it 'should return false' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = "selvyfitriani31@gmail.com",  
                    bio_description = 'a learner',
                )
                user.save
                
                post = Post.new(
                    id = 1,
                    user_id = user.id,
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05"
                )
                post.save

                comment = Comment.new(
                    user_id = user.id,
                    post_id = "",
                    text = "A new comment"  
                )

                expect(comment.valid?).to eq(false)
            end
        end

        context 'when given empty text' do
            it 'should return false' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = "selvyfitriani31@gmail.com",  
                    bio_description = 'a learner',
                )
                user.save
                
                post = Post.new(
                    id = 1,
                    user_id = user.id,
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05"
                )
                post.save

                comment = Comment.new(
                    user_id = user.id,
                    post_id = post.id,
                    text = ""  
                )

                expect(comment.valid?).to eq(false)
            end
        end

        context 'when given more than 1000 chars of text' do
            it 'should return false' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = "selvyfitriani31@gmail.com",  
                    bio_description = 'a learner',
                )
                user.save
                
                post = Post.new(
                    id = 1,
                    user_id = user.id,
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05"
                )
                post.save

                comment = Comment.new(
                    user_id = user.id,
                    post_id = post.id,
                    text = "A"*1001  
                )

                expect(comment.valid?).to eq(false)
            end
        end
    end

    describe '#generate_hashtags' do
        context 'when text has no hashtags' do
            it 'should return empty string' do
                comment = Comment.new(
                    user_id = 1,
                    post_id = 1,
                    text = "A new comment"  
                )
            
                hashtags = comment.generate_hashtags()
                expected_hashtags = ""
                expect(hashtags).to eq(expected_hashtags)
            end
        end 

        context 'when text has 1 hashtag' do
            it 'should return string with the hashtag' do
                comment = Comment.new(
                    user_id = 1,
                    post_id = 1,
                    text = "A new comment #gigih"  
                )

                hashtags = comment.generate_hashtags
                expected_hashtags = "#gigih "
                expect(hashtags).to eq(expected_hashtags)
            end
        end

        context 'when text contain multiple instances of a hashtag' do
            it 'should return only one hashtag' do
                comment = Comment.new(
                    user_id = 1,
                    post_id = 1,
                    text = "#hashtag #hashtaG #hasHtag"
                )

                hashtags = comment.generate_hashtags()
                expected_hashtags = "#hashtag "
                expect(hashtags).to eq(expected_hashtags)
            end
        end
    end

    describe '#save' do
        context 'when given invalid input' do
            it 'should not save to database and return false' do
                comment = Comment.new(
                    user_id = "",
                    post_id = "",
                    text = ""
                )

                expect(comment.save).to eq(false)
            end
        end

        context 'when given with valid input' do
            it 'should save to database and return true' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = "selvyfitriani31@gmail.com",  
                    bio_description = 'a learner',
                )
                user.save
                
                post = Post.new(
                    id = 1,
                    user_id = user.id,
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05"
                )
                post.save

                comment = Comment.new(
                    user_id = user.id,
                    post_id = post.id,
                    text = "A new comment"  
                )

                dummy_database = double
                allow(Mysql2::Client).to receive(:new).and_return(dummy_database)
                allow(dummy_database).to receive(:query).with("INSERT INTO comments(user_id, post_id, text, hashtags) " +
                    "VALUES(#{comment.user_id}, #{comment.post_id}, '#{comment.text}', '')")

                expect(comment.save).to eq(true)
            end
        end

        context 'when given text with hashtags' do
            it 'should generate all hashtags and save to database' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = "selvyfitriani31@gmail.com",  
                    bio_description = 'a learner',
                )
                user.save
                
                post = Post.new(
                    id = 1,
                    user_id = user.id,
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05"
                )
                post.save

                comment = Comment.new(
                    user_id = user.id,
                    post_id = post.id,
                    text = "A new comment #gigih"  
                )

                hashtags = comment.generate_hashtags

                dummy_database = double
                allow(Mysql2::Client).to receive(:new).and_return(dummy_database)
                allow(dummy_database).to receive(:query).with("INSERT INTO comments" +
                    "(user_id, post_id, text, hashtags) " +
                    "VALUES(#{comment.user_id}, #{comment.post_id}, '#{comment.text}', '#{hashtags}')")
                
                comment.save
                
                expected_hashtags = "#gigih "

                expect(hashtags).to eq(expected_hashtags)
            end
        end
    end
end