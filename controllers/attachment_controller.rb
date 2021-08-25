require './models/attachment'

class AttachmentController
  def create(params)
    attachment = Attachment.new(params['filename'], params['type'], params['post_id'])

    attachment.save

    post = Post.find_by_id(attachment.post_id)

    response = {}
    if post && attachment.save
      response['status_code'] = '201'
      response['message'] = 'Successfully insert attachment to database'
    else
      response['status_code'] = '400'
      response['message'] = 'Sorry! Creating new attachment is failed because invalid parameters'
    end

    JSON.generate(response)
  end
end