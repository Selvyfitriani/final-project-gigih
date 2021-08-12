class Post

    VALID_DATETIME_REGEX = /^\d{4}\-\d{2}\-\d{2} \d{2}\:\d{2}\:\d{2}$/

    def initialize(id=nil, user_id, text, datetime)
        @id = id
        @user_id = user_id
        @text = text
        @datetime = datetime
    end
    
    def valid?
        return false if !valid_user_id?
        return false if !valid_text?
        return false if !valid_datetime?
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

    def valid_datetime?
        return false if !(@datetime =~ VALID_DATETIME_REGEX)
        
        # datetime = [yyyy-mm-dd hh:mm:ss]
        year = @datetime[0,4]
        month = @datetime[5,2]
        day = @datetime[8,2]
        time = @datetime[11,8]

        return false if year < "2000"
        return false if month > "12"
        return false if day > "31"
        return false if time > "24:00:00"
        
        return true
    end

    def generate_hashtags
        return []
    end
end