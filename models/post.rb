require './database/db_connector'
require './models/user'

class Post
  attr_accessor :id, :user_id, :text, :datetime, :hashtags

  VALID_DATETIME_REGEX = /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/.freeze

  def initialize(user_id, text, datetime, id = nil, hashtags = '')
    @id = id
    @user_id = user_id
    @text = text
    @datetime = datetime
    @hashtags = hashtags
  end

  def valid?
    return false unless valid_user_id?
    return false unless valid_text?
    return false unless valid_datetime?

    true
  end

  def valid_user_id?
    int_user_id = @user_id.to_i

    return false if int_user_id <= 0

    true
  end

  def valid_text?
    return false if @text.empty?
    return false if @text.length > 1000

    true
  end

  def valid_datetime?
    return false unless @datetime =~ VALID_DATETIME_REGEX

    # datetime = [yyyy-mm-dd hh:mm:ss]
    year = @datetime[0, 4]
    month = @datetime[5, 2]
    day = @datetime[8, 2]
    time = @datetime[11, 8]

    return false if year < '2000'
    return false if month > '12'
    return false if day > '31'
    return false if time > '24:00:00'

    true
  end

  def generate_hashtags
    @hashtags = ''

    pieces = @text.split(' ')
    pieces.each do |piece|
      next if piece[0, 1] != '#'

      hashtag = piece.downcase
      next if @hashtags.include? hashtag

      @hashtags += hashtag
      @hashtags += ' '
    end

    @hashtags
  end

  def save
    return false unless valid?

    generate_hashtags

    client = create_db_client

    if @id
      client.query("INSERT INTO posts
          (id, user_id, text, datetime, hashtags)
          VALUES(#{@id}, #{@user_id}, '#{@text}', '#{@datetime}', '#{@hashtags}')")
    else
      client.query("INSERT INTO posts
          (user_id, text, datetime, hashtags)
          VALUES(#{@user_id}, '#{@text}', '#{@datetime}', '#{@hashtags}')")
    end

    true
  end

  def self.last_insert_id
    client = create_db_client
    raw_data = client.query('SELECT MAX(id) as id FROM posts')

    id = 0
    raw_data.each do |datum|
      id = datum['id'].to_i
    end

    id
  end

  def self.find_by_id(id)
    return nil if id.to_i <= 0

    client = create_db_client
    raw_data = client.query("SELECT * FROM posts WHERE id = #{id}")

    post = nil

    raw_data.each do |datum|
      post = Post.new(datum['user_id'], datum['text'], datum['datetime'], datum['id'], datum['hashtags'])
    end

    post
  end

  def self.find_all_by_hashtag(hashtag)
    client = create_db_client

    raw_data = client.query("SELECT * FROM posts WHERE hashtags LIKE '%##{hashtag} %'")

    posts = []

    raw_data.each do |datum|
      post = Post.new(datum['user_id'], datum['text'], datum['datetime'], datum['id'], datum['hashtags'])
      posts.push(post)
    end

    posts
  end

  def to_json
    json_post = {
      'user_id' => @user_id,
      'text' => @text,
      'datetime' => @datetime.strftime('%Y-%m-%d %H:%M:%S')
    }

    json_post
  end

  def self.trending
    hashtags_in_24_hours = find_all_hashtag_in_24_hours

    counted_hashtag = find_counted_hashtag(hashtags_in_24_hours)
    counted_hashtag = counted_hashtag.sort_by { |_, count| count }
    top_5_hashtag = counted_hashtag.last(5).reverse

    trending_hashtags = {}
    top_5_hashtag.each do |hashtag, num|
      trending_hashtags[hashtag] = num
    end

    trending_hashtags
  end

  def self.find_all_hashtag_in_24_hours
    client = create_db_client
    raw_data = client.query("SELECT posts.id AS id, posts.hashtags AS post_hashtags,
      comments.hashtags AS comment_hashtags
      FROM posts
      LEFT JOIN comments
      ON posts.id = comments.post_id
      WHERE TIMESTAMPDIFF(HOUR, now(), posts.datetime) > -24")

    hashtags = []
    id_containers = []
    raw_data.each do |datum|
      post_id = datum['id']
      hashtag_in_a_post = []
      unless id_containers.include?(post_id)
        id_containers << post_id
        hashtag_in_a_post = split_hashtags(datum['post_hashtags'])
      end
      hashtag_in_a_comment = split_hashtags(datum['comment_hashtags'])
      hashtags += hashtag_in_a_post
      hashtags += hashtag_in_a_comment
    end

    hashtags
  end

  def self.split_hashtags(hashtags)
    return [] if hashtags.nil?

    no_punctuation_hastaghs = hashtags.gsub(/[^a-z0-9\#]/, '')
    splitted_hastaghs = no_punctuation_hastaghs.split('#')

    hashtags = []
    splitted_hastaghs.each do |hashtag|
      if hashtag != ''
        hashtag = "##{hashtag}"
        hashtags << hashtag
      end
    end

    hashtags
  end

  def self.find_counted_hashtag(hashtags)
    counted_hashtag = {}

    hashtags.each do |hashtag|
      if counted_hashtag.key?(hashtag)
        counted_hashtag[hashtag] += 1
      else
        counted_hashtag[hashtag] = 1
      end
    end

    counted_hashtag
  end
end
