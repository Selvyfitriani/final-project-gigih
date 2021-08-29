require './models/attachment'

class AttachmentController
  def create(params)
    attachment =
      if params['post_id']
        create_post_attachment(params)
      elsif params['comment_id']
        create_comment_attachment(params)
      end

    post = Post.find_by_id(attachment.post_id)
    comment = Comment.find_by_id(attachment.comment_id)

    rendered = nil

    if post && attachment.save
      attachment_id = Attachment.last_insert_id
      attachment = Attachment.find_by_id(attachment_id)

      rendered = ERB.new(File.read('./views/success_create_post_attachment.erb'))
    elsif comment && attachment.save
      attachment_id = Attachment.last_insert_id
      attachment = Attachment.find_by_id(attachment_id)

      rendered = ERB.new(File.read('./views/success_create_comment_attachment.erb'))
    end

    rendered.result(binding)
  end

  def create_post_attachment(params)
    attachment = Attachment.new(params['filename'], params['type'], params['post_id'])
    attachment.save

    attachment
  end

  def create_comment_attachment(params)
    attachment = Attachment.new(params['filename'], params['type'], nil, params['comment_id'])
    attachment.save

    attachment
  end
end
