class Comment

  attr_accessor :id, :user_id, :post_id, :text, :hashtags

  def initialize(user_id, post_id, text, id = nil, hashtags = '')
    @id = id
    @user_id = user_id
    @post_id = post_id
    @text = text
    @hashtags = hashtags
  end

  def valid?
    return false unless valid_user_id?
    return false unless valid_post_id?
    return false unless valid_text?

    true
  end

  def valid_user_id?
    int_user_id = @user_id.to_i

    return false if int_user_id <= 0

    true
  end

  def valid_post_id?
    int_post_id = @post_id.to_i

    return false if int_post_id <= 0

    true
  end

  def valid_text?
    return false if @text.empty?
    return false if @text.length > 1000

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
      client.query("INSERT INTO comments(id, user_id, post_id, text, hashtags)
          VALUES(#{@id}, #{@user_id}, #{@post_id}, '#{@text}', '#{@hashtags}')")
    else
      client.query("INSERT INTO comments(user_id, post_id, text, hashtags)
          VALUES(#{@user_id}, #{@post_id}, '#{@text}', '#{@hashtags}')")
    end

    true
  end

  def self.last_insert_id
    client = create_db_client
    raw_data = client.query('SELECT MAX(id) as id FROM comments')

    id = 0
    raw_data.each do |datum|
      id = datum['id'].to_i
    end

    id
  end

  def self.find_by_id(id)
    return nil if id.to_i <= 0

    client = create_db_client
    raw_data = client.query("SELECT * FROM comments WHERE id = #{id}")

    comment = nil

    raw_data.each do |datum|
      comment = Comment.new(datum['user_id'], datum['post_id'], datum['text'], datum['id'], datum['hashtags'])
    end

    comment
  end
end
