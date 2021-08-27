require './controllers/response_generator'
require 'json'
require './models/post'

class PostController
  def create(params)
    post = Post.new(params['user_id'], params['text'], params['datetime'], params['id'])

    user = User.get_by_id(post.user_id)

    response = 
      if user && post.save
        ResponseGenerator.success_response('Successfully insert post to database')
      else
        ResponseGenerator.failed_response('Sorry! Creating new post is failed because invalid parameters')
      end

    JSON.generate(response)
  end

  def get_all_by_hashtag(params)
    hashtag = params['hashtag']
    posts = Post.get_all_by_hashtag(hashtag)

    response = ResponseGenerator.create_response(
      {
        'status_code' => '200',
        'posts' => []
      }
    )

    posts.each do |post|
      json_post = post.to_json
      response['posts'] << json_post
    end

    JSON.generate(response)
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

    JSON.generate(response)
  end
end
