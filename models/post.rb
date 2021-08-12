class Post
    def initialize(id=nil, user_id, text, time)
        @id = id
        @user_id = user_id
        @text = text
        @time = time
    end
    
    def valid?
        return false if @user_id < 0 
        return false if @text.empty?
        return false if @time.empty?
        return true
    end
end