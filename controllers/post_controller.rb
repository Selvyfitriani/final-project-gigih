require './controllers/response_generator'
require 'json'
require './models/post'

class PostController
  def create(params)
    post = Post.new(params['user_id'], params['text'], params['datetime'], params['id'])

    user = User.find_by_id(post.user_id)

    if user && post.save
      ResponseGenerator.success_response('Successfully insert post to database')
    else
      ResponseGenerator.failed_response('Sorry! Creating new post is failed because invalid parameters')
    end
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
