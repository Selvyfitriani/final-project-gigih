require 'json'
require './models/post'

class PostController 
    def create(params)
        post = Post.new(
            id = params["id"],
            user_id = params["user_id"],
            text = params["text"],
            datetime = params["datetime"]
        )
        
        user = User.get_by_id(post.user_id)
        
        response = {}
        if user && post.save
            response["status_code"] = "201"
            response["message"] = "Successfully insert post to database"
        else
            response["status_code"] = "400"
            response["message"] = "Sorry! Creating new post is failed because invalid parameters"
        end
        
        response = JSON.generate(response)
        response
    end

    def get_all_by_hashtag(params)
        hashtag = params["hashtag"]
        posts = Post.get_all_by_hashtag(hashtag)

        response = {}
        response["status_code"] = "200"
        response["posts"] = []
        
        posts.each do |post|
            json_post = post.to_json
            response["posts"] << json_post
        end

        response = JSON.generate(response)
        response
    end

    def transform_to_json(posts)
        json_posts = []
        
        posts.each do |post|
            json_post = post.to_json
            json_posts << json_post
        end

        json_posts 
    end

    def trending
        response = {}
        response["status_code"] = "200"
        response["trending"] = Post.trending

        JSON.generate(response)
    end
end