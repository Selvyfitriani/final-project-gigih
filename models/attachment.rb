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
    return false unless valid?

    client = create_db_client

    if valid_post_id?
      client.query("INSERT INTO attachments(filename, type, post_id)
          VALUES('#{@filename}', '#{@type}', #{@post_id})")
    elsif valid_comment_id?
      client.query("INSERT INTO attachments(filename, type, comment_id)
          VALUES('#{@filename}', '#{@type}', #{@comment_id})")
    end

    true
  end

  def self.last_insert_id
    client = create_db_client()
    raw_data = client.query('SELECT MAX(id) as id FROM attachments')

    raw_data.each do |datum|
      return datum['id'].to_i
    end
  end

  def self.find_by_id(id)
    client = create_db_client
    raw_data = client.query("SELECT * FROM attachments WHERE id = #{id}")

    attachment = nil

    raw_data.each do |datum|
      attachment = Attachment.new(datum['filename'], datum['type'], datum['post_id'])
    end

    attachment
  end
end
