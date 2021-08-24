require "./test_helper"
require "./database/db_connector"
require "./models/post"

describe Post do
    before (:each) do
        client = create_db_client
        client.query("DELETE FROM users")
        client.query("DELETE FROM posts")
    end

    describe '#valid?' do
        context 'when initialized with valid mandatory attributes value' do
            it 'should return true' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = "selvyfitriani31@gmail.com",  
                    bio_description = 'a learner',
                )

                user.save
                
                post = Post.new(
                    user_id = user.id,
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05"
                )

                expect(post.valid?).to eq(true)

                User.delete(user.id)
            end
        end

        context 'when initialized with user id in alphabetical form' do
            it 'should return false' do
                post = Post.new(
                    user_id = "a",
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05"
                )

                expect(post.valid?).to eq(false)
            end
        end

        context 'when initialized with string-formatted valid user id' do
            it 'should return true' do
                post = Post.new(
                    user_id = "1",
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05"
                )

                expect(post.valid?).to eq(true)
            end
        end

        context 'when initialized with too long text' do
            it 'should return false' do
                post = Post.new(
                    user_id = 1,
                    text = "a"*1001,
                    datetime = "2021-08-21 22:30:05"
                )

                expect(post.valid?).to eq(false)
            end
        end

        context 'when initialized with invalid format datetime' do
            it 'should return false' do
                post = Post.new(
                    user_id = 1,
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05a"
                )

                expect(post.valid?).to eq(false)
            end
        end

        context 'when initialized with out of range datetime' do
            it 'should return false' do
                post = Post.new(
                    user_id = 1,
                    text = "A new post",
                    datetime = "2021-13-21 22:30:05"
                )

                expect(post.valid?).to eq(false)
            end
        end

        context 'when intialized with out of of range time' do
            it 'should return false' do
                post = Post.new(
                    user_id = 1,
                    text = "A new post",
                    datetime = "2021-12-30 24:00:05"
                )

                expect(post.valid?).to eq(false)
            end
        end
    end

    describe '#generate_hashtags' do
        context 'when text has no hashtags' do
            it 'should return empty string' do
                post = Post.new(
                    user_id = 1,
                    text = "A new post",
                    datetime = "2021-12-31 24:00:05"
                )
            
                hashtags = post.generate_hashtags()
                expected_hashtags = ""
                expect(hashtags).to eq(expected_hashtags)
            end
        end 

        context 'when text has 1 hashtag' do
            it 'should return string with the hashtag' do
                post = Post.new(
                    user_id = 1,
                    text = "A new post #ini_hashtag",
                    datetime = "2021-12-31 24:00:05"
                )

                hashtags = post.generate_hashtags()
                expected_hashtags = "#ini_hashtag "
                expect(hashtags).to eq(expected_hashtags)
            end
        end

        context 'when text has 1 hashtag in the middle' do
            it 'should return string with the hashtag' do
                post = Post.new(
                    user_id = 1,
                    text = "A new post #middle_hashtag in my account",
                    datetime = "2021-12-31 24:00:05"
                )

                hashtags = post.generate_hashtags()
                expected_hashtags = "#middle_hashtag "
                expect(hashtags).to eq(expected_hashtags)
            end
        end

        context 'when text contain multiple instances of a hashtag' do
            it 'should return only one hashtag' do
                post = Post.new(
                    user_id = 1,
                    text = "#hashtag #hashtaG #hasHtag",
                    datetime = "2021-12-31 24:00:05"
                )

                hashtags = post.generate_hashtags()
                expected_hashtags = "#hashtag "
                expect(hashtags).to eq(expected_hashtags)
            end
        end
    end

    describe '#save' do
        context 'when given invalid input' do
            it 'should not save to database and return false' do
                post = Post.new(
                    user_id = 1, 
                    text = "A new post"*1000,
                    datetime = "2021-08-21 22:30:05"
                )

                expect(post.save).to eq(false)
            end
        end

        context 'when given valid input' do
            it 'should save to database and return true' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = 'selvyfitriani31@gmail.com',
                    bio_description = 'a learner'
                )

                user.save

                post = Post.new(
                    user_id = user.id, 
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05"
                )
                
                dummy_database = double
                allow(Mysql2::Client).to receive(:new).and_return(dummy_database)
                
                hashtags = post.generate_hashtags
                allow(dummy_database).to receive(:query).with("INSERT INTO posts" +
                    "(user_id, text, datetime, hashtags) " +
                    "VALUES(#{post.user_id}, '#{post.text}', '#{post.datetime}', '#{hashtags}')")
                response = post.save
                
                expect(response).to eq(true)
            end
        end

        context 'when given initial id' do
            it 'should save to database and return true' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = 'selvyfitriani31@gmail.com',
                    bio_description = 'a learner'
                )

                user.save

                post = Post.new(
                    id = 1,
                    user_id = user.id, 
                    text = "A new post",
                    datetime = "2021-08-21 22:30:05"
                )
                
                dummy_database = double
                allow(Mysql2::Client).to receive(:new).and_return(dummy_database)
                
                hashtags = post.generate_hashtags
                allow(dummy_database).to receive(:query).with("INSERT INTO posts" +
                    "(id, user_id, text, datetime, hashtags) " +
                    "VALUES(#{post.id}, #{post.user_id}, '#{post.text}', '#{post.datetime}', '#{hashtags}')")
                response = post.save
                
                expect(response).to eq(true)
            end
        end

        context 'when given text with hashtags' do
            it 'should generate all hashtags and save to database' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = 'selvyfitriani31@gmail.com',
                    bio_description = 'a learner'
                )
                user.save
 
                post = Post.new(
                    user_id = 1, 
                    text = "A new post #gigih #Gigih #semangat",
                    datetime = "2021-08-21 22:30:05"
                )
                
                dummy_database = double
                allow(Mysql2::Client).to receive(:new).and_return(dummy_database)
                
                hashtags = post.generate_hashtags()
                allow(dummy_database).to receive(:query).with("INSERT INTO posts(user_id, text, datetime, hashtags) " +
                    "VALUES(#{post.user_id}, '#{post.text}', '#{post.datetime}', '#{hashtags}')")
                post.save
                
                expected_hashtags = "#gigih #semangat "
                expect(hashtags).to eq(expected_hashtags)
            end
        end
    end

    describe '.get_all_by_hashtag' do 
        context 'when there are no posts that contain the hashtag' do
            it 'should return empty array' do
                search_hashtag = 'gigih'
                posts = Post.get_all_by_hashtag(search_hashtag)
                
                expected_posts = []

                expect(posts).to eq(expected_posts)
            end
        end

        context 'when there is one post that contain the hashtag' do
            it 'should return array that includes the post' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = 'selvyfitriani31@gmail.com',
                    bio_description = 'a learner'
                ) 
                user.save
                
                post = Post.new(
                    user_id = user.id, 
                    text = "I am a superhero #gigih #Semangat",
                    datetime = "2021-08-21 22:30:05"
                )
                
                post.save
                
                search_hashtag = "gigih"
                posts = Post.get_all_by_hashtag(search_hashtag)

                dummy_database = double
                allow(Mysql2::Client).to receive(:new).and_return(dummy_database)
                allow(dummy_database).to receive(:query).with("SELECT * FROM posts " +
                     "WHERE hashtags LIKE '%##{search_hashtag} %'")
                expect(posts.length).to eq(1)
            end
        end

        context 'when searched hashtag not full' do
            it 'should not return the posts' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = 'selvyfitriani31@gmail.com',
                    bio_description = 'a learner'
                ) 
                user.save
                
                post = Post.new(
                    user_id = user.id, 
                    text = "I am a superhero #gigih #Semangat",
                    datetime = "2021-08-21 22:30:05"
                )
                
                post.save
                
                search_hashtag = "gig"
                posts = Post.get_all_by_hashtag(search_hashtag)

                dummy_database = double
                allow(Mysql2::Client).to receive(:new).and_return(dummy_database)
                allow(dummy_database).to receive(:query).with("SELECT * FROM posts " +
                     "WHERE hashtags LIKE '%##{search_hashtag} %'")
                    
                expect(posts.length).to eq(0)
            end
        end
    end 

    describe '#trending' do
        context 'when there is no trending hashtag' do
            it 'should return empty list' do
                trending_hashtags = Post.trending
                
                expect(trending_hashtags.length).to eq(0)
            end
        end

        context 'when there is one trending hashtag' do
            it 'should return list of hashtag' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = 'selvyfitriani31@gmail.com',
                    bio_description = 'a learner'
                )
                user.save
                
                post = Post.new(
                    user_id = user.id, 
                    text = "A new post #gigih",
                    datetime = (DateTime.now - 0.2).strftime("%F %T")
                )
                post.save

                trending_hashtags = Post.trending
                expected_trending_hashtags = ["#gigih"]

                expect(trending_hashtags).to eq(expected_trending_hashtags)
            end
        end

        context 'when there are two trending hashtags in one post' do
            it 'should return list of the two trending hashtag' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = 'selvyfitriani31@gmail.com',
                    bio_description = 'a learner'
                )
                user.save
                
                post = Post.new(
                    user_id = user.id, 
                    text = "A new post #gigih #semangat",
                    datetime = (DateTime.now - 0.2).strftime("%F %T")
                )

                post.save
            
                trending_hashtags = Post.trending
                expected_trending_hashtags = ["#semangat","#gigih"]

                expect(trending_hashtags).to eq(expected_trending_hashtags)
            end
        end

        context 'when there are two comment with hashtags in one post' do
          it 'should rcount hashtags in post just one time' do
              user = User.new(
                  id = 1,
                  username = 'selvyfitriani31',
                  email = "selvyfitriani31@gmail.com",  
                  bio_description = 'a learner'
              )
              user.save
              
              post = Post.new(
                  id = 1,
                  user_id = user.id,
                  text = "A new post #gigih",
                  datetime = (DateTime.now - 0.2).strftime("%F %T")
              )
              post.save

              comment = Comment.new(
                  user_id = user.id,
                  post_id = post.id,
                  text = "A new comment #semangat"  
              )
              
              comment_num = 2

              1.upto(comment_num) do |num|
                comment.save
              end
              

              trending_hashtags = Post.trending
              expected_trending_hashtags = ["#semangat", "#gigih"]

              expect(trending_hashtags).to eq(expected_trending_hashtags)
          end
      end

        context 'when there is hashtag in comment' do
            it 'should counted in trending' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = "selvyfitriani31@gmail.com",  
                    bio_description = 'a learner'
                )
                user.save
                
                post = Post.new(
                    id = 1,
                    user_id = user.id,
                    text = "A new post",
                    datetime = (DateTime.now - 0.2).strftime("%F %T")
                )
                post.save

                comment = Comment.new(
                    user_id = user.id,
                    post_id = post.id,
                    text = "A new comment #gigih"  
                )
                
                comment.save

                trending_hashtags = Post.trending
                expected_trending_hashtags = ["#gigih"]

                expect(trending_hashtags).to eq(expected_trending_hashtags)
            end
        end
    end
end