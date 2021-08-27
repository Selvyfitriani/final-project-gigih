require './controllers/response_generator'
require './models/comment'

class CommentController
  def create(params)
    comment = Comment.new(params['user_id'], params['post_id'], params['text'])

    user = User.get_by_id(comment.user_id)
    post = Post.find_by_id(comment.post_id)

    if user && post && comment.save
      ResponseGenerator.success_response('Successfully insert comment to database')
    else
      ResponseGenerator.failed_response('Sorry! Creating new comment is failed because invalid parameters')
    end
  end
end
