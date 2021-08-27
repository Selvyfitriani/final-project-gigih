require './models/user'
require 'json'

class UserController
  def create(params)
    user = User.new(params['username'], params['email'], params['bio_description'], params['id'])
    response = 
      if user.save
        ResponseGenerator.success_response('Successfully insert user to database')
      else
        ResponseGenerator.failed_response('Sorry! Creating new user is failed because invalid parameters')
      end

    JSON.generate(response)
  end
end
