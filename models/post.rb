class Post
    def initialize(id=nil, user_id, text, datetime)
        @id = id
        @user_id = user_id
        @text = text
        @datetime = datetime
    end
    
    def valid?
        return false if !valid_user_id?
        return false if !valid_text?
        return false if @datetime.empty?
        return true
    end

    def valid_user_id?
        return false if !@user_id.is_a? Integer
        return false if @user_id < 0
        return true 
    end

    def valid_text?
        return false if @text.empty?
        return false if @text.length > 1000
        return true
    end
end