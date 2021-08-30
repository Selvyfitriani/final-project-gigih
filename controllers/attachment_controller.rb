require './models/attachment'

class AttachmentController
  def create(params)
    attachment =
      if params['post_id']
        create_post_attachment(params)
      elsif params['comment_id']
        create_comment_attachment(params)
      end
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
