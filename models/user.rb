class User
    def initialize(id=nil, username, email, bio_description)
        @id = id
        @username = username
        @email = email
        @bio_description = bio_description
    end

    def valid?
        return false if @username.nil?
        return false if @email.nil?
        return false if @bio_description.nil?
        return true
    end
end