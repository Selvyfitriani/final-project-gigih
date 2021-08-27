require './controllers/response_generator'
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

    response = 
      if post && attachment.save
        ResponseGenerator.success_response('Successfully insert attachment to database')
      else
        ResponseGenerator.failed_response('Sorry! Creating new attachment is failed because invalid parameters')
      end

    JSON.generate(response)
  end

  def create_post_attachment(params)
    attachment = Attachment.new(params['filename'], params['type'], params['post_id'])
    attachment.save

    attachment
  end

  def create_comment_attachment(params)
    attachment = Attachment.new(params['filename'], params['type'], params['comment_id'])
    attachment.save

    attachment
  end
end
