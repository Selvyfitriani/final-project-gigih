require './models/attachment'

class AttachmentController
  def create(params)
    if params['post_id']
      create_post_attachment(params)
    elsif params['comment_id']
      create_comment_attachment(params)
    end
  end

  def save_attachment(params)
    filename = params['filename']
    tempfile = params['tempfile']
    path = '/home/selvy/Documents/gigih/final-project-gigih/uploads'

    File.open(File.join(path, filename.to_s), 'wb') do |file|
      file.write(tempfile.read)
    end
  end

  def create_post_attachment(params)
    attachment = Attachment.new(params['attachment']['filename'], params['attachment']['type'], params['id'])
    attachment.save

    attachment
  end

  def create_comment_attachment(params)
    attachment = Attachment.new(params['attachment']['filename'], params['attachment']['type'], nil, params['id'])
    attachment.save

    attachment
  end
end
