require "./test_helper"
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
             
                post_params = {
                    "user_id" => user_params["id"],
                    "text" => "A new post",
                    "datetime" => "2021-08-21 22:30:05"   
                }
                post_controller = PostController.new
                response = post_controller.create(post_params)

                post_id = Post.get_last_insert_id()
                expected_post = Post.get_by_id(post_id)
                expect(expected_post).not_to be nil

                expected_response = JSON.generate({"status_code" => "201", "message" => "Successfully insert post to database"})
                expect(response).to eq(expected_response)
            end
        end

        context 'when given non-existent user id' do
            it 'should not save to database and return error message in response' do
                params = {
                    "user_id" => 1,
                    "text" => "A new post",
                    "datetime" => "2021-08-21 22:30:05"   
                }

                controller = PostController.new
                response = controller.create(params)

                post_id = Post.get_last_insert_id()
                expected_post = Post.get_by_id(post_id)
                expect(expected_post).to be nil

                expected_response = JSON.generate({"status_code" => "400", "message" => "Sorry! Creating new post is failed because invalid parameters"})
                expect(response).to eq(expected_response)
            end
        end
    end

    describe '#get_all_by_hashtag' do
        context 'when there is no post that contain the hashtag' do
            it 'should return an empty list' do
                params = { "hashtag" => "gigih" }
                
                controller = PostController.new
                response = controller.get_all_by_hashtag(params)

                expected_response = JSON.generate({
                    "status_code" => "200",  
                    "posts" => []
                })
                expect(response).to eq(expected_response)
            end
        end

        context 'when there is one post that contain hashtag' do
            it 'should return the post in a list' do
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

                params = { "hashtag" => "gigih" }
                posts = Post.get_all_by_hashtag(params["hashtag"])
                
                controller = PostController.new
                json_posts = controller.transform_to_json(posts)
                response = controller.get_all_by_hashtag(params)
                expected_response = JSON.generate({
                    "status_code" => "200",  
                    "posts" => json_posts
                })
                expect(response).to eq(expected_response)
            end
        end

        context 'when there are more than one post' do
            it 'should return list of posts in json format' do
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
                
                post_num = 3
                1.upto(post_num) do |num|
                    post.save
                end

                params = { "hashtag" => "gigih" }
                posts = Post.get_all_by_hashtag(params["hashtag"])
                
                controller = PostController.new
                json_posts = controller.transform_to_json(posts)
                response = controller.get_all_by_hashtag(params)
                expected_response = JSON.generate({
                    "status_code" => "200",  
                    "posts" => json_posts
                })
                expect(response).to eq(expected_response)
            end
        end
    end

    describe '#transform_to_json' do
        context 'when there is no post' do
            it 'should return empty array' do
                search_hashtag = "gigih"
                posts = Post.get_all_by_hashtag(search_hashtag)
                
                controller = PostController.new
                json_posts = controller.transform_to_json(posts)

                expected_json_posts = []

                expect(json_posts).to eq(expected_json_posts)
            end
        end

        context 'when there is one post' do
            it 'should return list of detail post in json format' do
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
                controller = PostController.new
                json_posts = controller.transform_to_json(posts)

                expected_json_posts = [{
                    "user_id" => post.user_id,
                    "text" => post.text,
                    "datetime" => post.datetime
                }]
                
                expect(json_posts).to eq(expected_json_posts)
            end
        end

        context 'when there are more than one post' do
            it 'should return list of detail posts in json format' do
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
                
                post_num = 3
                1.upto(post_num) do |num|
                    post.save
                end
                
                search_hashtag = "gigih"
                
                posts = Post.get_all_by_hashtag(search_hashtag)
                controller = PostController.new
                json_posts = controller.transform_to_json(posts)

                expected_json_posts = [
                    {
                    "user_id" => post.user_id,
                    "text" => post.text,
                    "datetime" => post.datetime
                    },
                    {
                        "user_id" => post.user_id,
                        "text" => post.text,
                        "datetime" => post.datetime
                    },
                    {
                        "user_id" => post.user_id,
                        "text" => post.text,
                        "datetime" => post.datetime
                    }
                ]
                
                expect(json_posts).to eq(expected_json_posts)
            end
        end
    end

    describe '#trending' do
        context 'when there is no trending hashtag' do
            it 'should return response with empty list' do
                controller = PostController.new
                response = controller.trending

                expected_response = JSON.generate({
                    "status_code" => "200",
                    "trending" => [] 
                })

                expect(response).to eq(expected_response)
            end
        end

        context 'when there is one trending hashtag' do
            it 'should return response with list of hashtag' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = 'selvyfitriani31@gmail.com',
                    bio_description = 'a learner'
                ) 
                user.save
                
                post = Post.new(
                    user_id = user.id, 
                    text = "I am a superhero #gigih",
                    datetime = "2021-08-21 22:30:05"
                )

                post.save

                trending_hashtags = Post.trending
                controller = PostController.new
                response = controller.trending

                expected_response = JSON.generate({
                    "status_code" => "200",
                    "trending" => trending_hashtags
                })

                expect(response).to eq(expected_response)
            end
        end

        context 'when there are more than one trending hashtag' do
            it 'should return response with list of hashtags' do
                user = User.new(
                    id = 1,
                    username = 'selvyfitriani31',
                    email = 'selvyfitriani31@gmail.com',
                    bio_description = 'a learner'
                ) 
                user.save
                
                post = Post.new(
                    user_id = user.id, 
                    text = "I am a superhero #gigih #semangat",
                    datetime = "2021-08-21 22:30:05"
                )

                post_num = 3
                1.upto(post_num) do |num|
                    post.save
                end

                trending_hashtags = Post.trending
                controller = PostController.new
                response = controller.trending

                expected_response = JSON.generate({
                    "status_code" => "200",
                    "trending" => trending_hashtags
                })

                expect(response).to eq(expected_response)
            end
        end
    end
end