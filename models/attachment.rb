class Attachment

  def initialize(filename, type, post_id = nil, comment_id = nil, id = nil)
    @filename = filename
    @type = type,
    @post_id = post_id,
    @comment_id = comment_id
    @id = id
  end

  def valid?
    return false if @filename.empty?
    return false if @type.empty?

    true
  end
end