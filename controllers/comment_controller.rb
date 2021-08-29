require './models/comment'

class CommentController
  def create(params)
    comment = Comment.new(params['user_id'], params['post_id'], params['text'], params['id'])

    user = User.find_by_id(comment.user_id)
    post = Post.find_by_id(comment.post_id)

    if user && post && comment.save
      comment_id = Comment.last_insert_id
      comment = Comment.find_by_id(comment_id)

      rendered = ERB.new(File.read('./views/success_create_comment.erb'))
    else
      rendered = ERB.new(File.read('./views/failed_create_comment.erb'))
    end

    rendered.result(binding)
  end
end
