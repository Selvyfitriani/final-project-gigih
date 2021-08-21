require "./models/comment"

class CommentController
    def create(params)
        comment = Comment.new(
            user_id = params["user_id"],
            post_id = params["post_id"],
            text = params["text"]
        )
        
        comment.save
        
        response = {}
        response["status_code"] = "201"
        response["message"] = "Successfully insert comment to database"
        
        response = JSON.generate(response)
        response
    end

end