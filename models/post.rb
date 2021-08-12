class Post
    def initialize(id=nil, user_id, text, time)
        @id = id
        @user_id = user_id
        @text = text
        @time = time
    end
    
    def valid?
        return false if !valid_user_id?
        return false if @text.empty?
        return false if @time.empty?
        return true
    end

    def valid_user_id?
        return false if !@user_id.is_a? Integer
        return false if @user_id < 0
        return true 
    end
end