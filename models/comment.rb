class Comment 

    attr_accessor :user_id, :post_id, :text

    def initialize(id=nil, user_id, post_id, text)
        @id = id
        @user_id = user_id
        @post_id = post_id
        @text = text
        @hashtags = ""
    end

    def valid?
        return false if !valid_user_id?
        return false if !valid_post_id?
        return false if !valid_text?
        return true
    end

    def valid_user_id?
        int_user_id = @user_id.to_i
     
        return false if int_user_id <= 0
        return true
    end

    def valid_post_id?
        int_post_id = @post_id.to_i

        return false if int_post_id <= 0
        return true
    end

    def valid_text?
        return false if @text.empty?
        return false if @text.length > 1000
        return true
    end

    def generate_hashtags
        @hashtags = ""

        pieces = @text.split(" ")
        pieces.each do |piece| 
            if piece[0, 1] == "#" 
                hashtag = piece.downcase
                if !@hashtags.include? hashtag
                    @hashtags += hashtag
                    @hashtags += " "
                end
            end 
        end

        @hashtags
    end

    def save
        return false if !valid?

        client = create_db_client
        client.query("INSERT INTO comments(user_id, post_id, text, hashtags) " + 
            "VALUES(#{@user_id}, #{@post_id}, '#{@text}', '#{@hashtags}')")
        
        return true
    end
end