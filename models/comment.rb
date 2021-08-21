class Comment 
    def initialize(id=nil, user_id, post_id, text)
        @id = id
        @user_id = user_id
        @post_id = post_id
        @text = text
    end

    def valid?
        return false if !valid_user_id?
        return true
    end

    def valid_user_id?
        int_user_id = @user_id.to_i

        return false if int_user_id <= 0
        return true
    end
end