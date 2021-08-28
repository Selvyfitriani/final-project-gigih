require './models/user'
require 'json'

class UserController
  def create(params)
    user = User.new(params['username'], params['email'], params['bio_description'], params['id'])

    rendered = nil
    if user.save
      user_id = User.last_insert_id
      user = User.find_by_id(user_id)

      rendered = ERB.new(File.read('./views/success_create_user.erb'))
    else
      rendered = ERB.new(File.read('./views/failed_create_user.erb'))
    end

    rendered.result(binding)
  end
end
