require './models/attachment'
require 'tempfile'

class AttachmentController
  def create(params)
    if params['comment_id']
      create_comment_attachment(params)
    elsif params['post_id']
      create_post_attachment(params)
    end

    save_attachment(params)
  end

  def save_attachment(params)
    filename = params['attachment']['filename']
    tempfile = params['attachment']['tempfile']
    path = '/home/selvy/Documents/gigih/final-project-gigih/uploads'
    file_path = File.join(path, filename.to_s)
 
    if !File.directory? file_path
      File.open(file_path, 'wb') do |file|
        file.write(tempfile.read)
      end
    end
  end

  def create_post_attachment(params)
    attachment = Attachment.new(params['attachment']['filename'], params['attachment']['type'], params['post_id'])
    attachment.save

    attachment
  end

  def create_comment_attachment(params)
    attachment = Attachment.new(params['attachment']['filename'], params['attachment']['type'], nil, params['comment_id'])
    attachment.save

    attachment
  end
end
