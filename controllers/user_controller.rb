require "./models/user"
require "json"

class UserController
    def create(params)
        user = User.new(
            username = params["username"],
            email = params["email"],
            bio_description = params["bio_description"]
        )
        response = {}

        if user.save
            response["status_code"] = "201"
            response["message"] = "Successfully insert user to database"
        end
        
        response = JSON.generate(response)
        response
    end
end        