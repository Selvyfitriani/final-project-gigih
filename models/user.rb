class User
    def initialize(id=nil, username, email, bio_description)
        @id = id
        @username = username
        @email = email
        @bio_description = bio_description
    end

    def valid?
        return false if @username.empty?
        return false if @email.empty?
        return false if @bio_description.empty?
        return true
    end
end