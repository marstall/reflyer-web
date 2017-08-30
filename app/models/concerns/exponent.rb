require 'httparty'

class Exponent
    def self.is_exponent_push_token?(token)
      token.start_with?('ExponentPushToken')
    end

    def self.publish(messages)
      response = HTTParty.post('https://exp.host/--/api/v2/push/send',
        body: messages.to_json,
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'Accept-Encoding' => 'gzip, deflate'
        }
      )
      return response
    end
end