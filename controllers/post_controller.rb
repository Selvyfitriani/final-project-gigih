require './controllers/response_generator'
require 'json'
require './models/post'

class PostController
  def create(params)
    post = Post.new(params['user_id'], params['text'], params['datetime'], params['id'])

    user = User.find_by_id(post.user_id)

    rendered = nil
    if user && post.save
      post_id = Post.last_insert_id
      post = Post.find_by_id(post_id)

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

    response = ResponseGenerator.create_response(
      {
        'status_code' => '200',
        'posts' => json_posts
      }
    )
  end

  def transform_to_json(posts)
    json_posts = []

    posts.each do |post|
      json_post = post.to_json
      json_posts << json_post
    end

    json_posts
  end

  def trending
    response = ResponseGenerator.create_response(
      {
        'status_code' => '200',
        'trending' => Post.trending
      }
    )

    response
  end
end
