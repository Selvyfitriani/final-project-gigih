require './models/comment'

class CommentController
  def create(params)
    comment = Comment.new(params['user_id'], params['post_id'], params['text'])

    user = User.get_by_id(comment.user_id)
    post = Post.find_by_id(comment.post_id)

    response = {}
    if user && post && comment.save
      response['status_code'] = '201'
      response['message'] = 'Successfully insert comment to database'
    else
      response['status_code'] = '400'
      response['message'] = 'Sorry! Creating new comment is failed because invalid parameters'
    end

    JSON.generate(response)
  end
end
