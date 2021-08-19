require "./models/user"
require "json"

class UserController
    def create(params)
        user = User.new(
            id = params["id"],
            username = params["username"],
            email = params["email"],
            bio_description = params["bio_description"]
        )
        response = {}

        if user.save
            response["status_code"] = "201"
            response["message"] = "Successfully insert user to database"
        else
            response["status_code"] = "400"
            response["message"] = "Sorry! Creating new user is failed because invalid parameters"
        end
        
        response = JSON.generate(response)
        response
    end
end        