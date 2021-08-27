class ResponseGenerator
  def self.create_response(params)
    response = {}
    params.each do |key, value|
      response[key] = value
    end

    response
  end

  def self.success_response(message)
    params = {
      'status_code' => '201',
      'message' => message
    }

    create_response(params)
  end

  def self.failed_response(message)
    params = {
      'status_code' => '400',
      'message' => message
    }

    create_response(params)
  end
end
