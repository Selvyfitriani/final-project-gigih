class Attachment

  attr_accessor :filename, :type, :post_id, :comment_id

  def initialize(filename, type, post_id = nil, comment_id = nil, id = nil)
    @filename = filename
    @type = type
    @post_id = post_id
    @comment_id = comment_id
    @id = id
  end

  def valid?
    return false if @filename.empty?
    return false if @type.empty?
    return false unless valid_post_id? ^ valid_comment_id?

    true
  end

  def valid_post_id?
    return true if @post_id.to_i.positive?

    false
  end

  def valid_comment_id?
    return true if @comment_id.to_i.positive?

    false
  end

  def save
    client = create_db_client

    if valid_post_id?
      client.query("INSERT INTO attachment(filename, type, post_id)
          VALUES('#{@filename}', '#{@type}', #{@post_id}")
    elsif valid_comment_id?
      client.query("INSERT INTO attachment(filename, type, comment_id)
          VALUES('#{@filename}', '#{@type}', #{@post_id}")
    end

    true
  end
end
