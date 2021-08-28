require "./database/db_connector"

class User
  # Source valid email regex: https://www.youtube.com/watch?v=Ch-KRivqmzU
  # docs of regex: https://rubular.com/

  attr_accessor :id, :username, :email, :bio_description

  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze

  def initialize(username, email, bio_description, id = nil)
    @id = id
    @username = username
    @email = email
    @bio_description = bio_description
  end

  def valid?
    return false unless valid_username?
    return false unless valid_email?
    return false unless valid_bio?

    true
  end

  def valid_username?
    !@username.empty? && @username.length <= 30
  end

  def valid_email?
    @email =~ VALID_EMAIL_REGEX
  end

  def valid_bio?
    !@bio_description.empty? && @bio_description.length <= 150
  end

  def save
    return false unless valid?

    client = create_db_client

    if @id
      client.query("INSERT INTO users(id, username, email, bio_description)
          VALUES(#{@id}, '#{@username}', '#{@email}', '#{bio_description}')")
    else
      client.query("INSERT INTO users(username, email, bio_description)
          VALUES('#{@username}', '#{@email}', '#{bio_description}')")
    end

    true
  end

  def self.last_insert_id
    client = create_db_client
    raw_data = client.query('SELECT MAX(id) as id FROM users')

    id = 0
    raw_data.each do |datum|
      id = datum['id'].to_i
    end

    id
  end

  def self.find_by_id(id)
    client = create_db_client
    raw_data = client.query("SELECT * FROM users WHERE id = #{id}")

    user = nil
    raw_data.each do |datum|
      user = User.new(datum['username'], datum['email'], datum['bio_description'], datum['id'])
    end

    user
  end

  def self.delete(id)
    client = create_db_client
    client.query("DELETE FROM users WHERE id=#{id}")
  end
end
