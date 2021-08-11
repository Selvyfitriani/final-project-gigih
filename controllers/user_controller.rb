require "./models/user"

class UserController
    def create(params)
        user = User.new(
            username = params["username"],
            email = params["email"],
            bio_description = params["bio_description"]
        )
        user.save
    end
end        