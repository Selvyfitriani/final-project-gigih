require "./database/db_connector"
require "./models/user"

class Post

    attr_accessor :user_id, :text, :datetime

    VALID_DATETIME_REGEX = /^\d{4}\-\d{2}\-\d{2} \d{2}\:\d{2}\:\d{2}$/

    def initialize(id=nil, user_id, text, datetime)
        @id = id
        @user_id = user_id
        @text = text
        @datetime = datetime
        @hashtags = ""
    end
    
    def valid?
        return false if !valid_user_id?
        return false if !valid_text?
        return false if !valid_datetime?
        return true
    end

    def valid_user_id?
        int_user_id = @user_id.to_i

        return false if int_user_id <= 0
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
        return false unless valid?
       
        generate_hashtags

        client = create_db_client
        client.query("INSERT INTO posts(user_id, text, datetime, hashtags) " +
            "VALUES(#{@user_id}, '#{@text}', '#{@datetime}', '#{@hashtags}')")
        return true
    end

    def self.get_last_insert_id
        client = create_db_client()
        raw_data = client.query("SELECT MAX(id) as id FROM posts")

        raw_data.each do |datum|
            return datum["id"].to_i
        end    
    end

    def self.get_by_id(id)
        client = create_db_client
        raw_data = client.query("SELECT * FROM posts WHERE id = #{id}")
        
        post = nil

        raw_data.each do |datum|
            post = Post.new(
                user_id = datum["user_id"], 
                text = datum["text"], 
                datetime = datum["datetime"]
            )
        end

        post
    end

    def self.get_all_by_hashtag(hashtag)
        client = create_db_client

        raw_data = client.query("SELECT * FROM posts WHERE hashtags LIKE '%##{hashtag} %'")
        
        posts = []
       
        raw_data.each do |datum|
            post = Post.new(
                user_id = datum["user_id"], 
                text = datum["text"], 
                datetime = datum["datetime"]
            )
            posts.push(post)
        end
       
        posts
    end
end