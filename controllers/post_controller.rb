require 'json'
require './models/post'

class PostController 
    def create(params)
        post = Post.new(
            user_id = params["user_id"],
            text = params["text"],
            datetime = params["datetime"]
        )
        
        user = User.find_by_id(post.user_id)
        
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
end