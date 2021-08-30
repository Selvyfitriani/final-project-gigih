require 'json'
require './controllers/attachment_controller'
require './models/post'

class PostController
  def create(params)
    post = Post.new(params['user_id'], params['text'], params['datetime'], params['id'])

    user = User.find_by_id(post.user_id)

    rendered = nil
    if user && post.save
      post_id = Post.last_insert_id
      post = Post.find_by_id(post_id)

      params['post_id'] = post_id
      if params['attachment']
        attachment_controller = AttachmentController.new
        attachment_controller.create(params)
      end

      rendered = ERB.new(File.read('./views/success_create_post.erb'))
    else
      rendered = ERB.new(File.read('./views/failed_create_post.erb'))
    end
    rendered.result(binding)
  end

  def find_all_by_hashtag(params)
    hashtag = params['hashtag']
    posts = Post.find_all_by_hashtag(hashtag)

    json_posts = []
    posts.each do |post|
      json_post = post.to_json
      json_posts << json_post
    end

    rendered = ERB.new(File.read('./views/posts_by_hashtag.erb'))
    rendered.result(binding)
  end

  def trending
    trending_hashtags = Post.trending
    rendered = ERB.new(File.read('./views/trending_hashtags.erb'))

    rendered.result(binding)
  end
end
