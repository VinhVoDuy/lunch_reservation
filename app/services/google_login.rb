class GoogleLogin
  PEOPLE_API = 'https://www.googleapis.com/plus/v1/people/me'
  attr_reader :result, :error, :response
  def initialize google_access_token
    @access_token = google_access_token
  end

  def run
    raw_response = RestClient.get(PEOPLE_API, params: { access_token: @access_token })
    @response = JSON.parse(raw_response.body)
    if raw_response.code == 200
      @result = { email: @response['emails'].first['value'], name: @response['displayName'] }
      true
    else
      @error = @response['error']['errors'].first['message']
      false
    end

  rescue RestClient::Forbidden, RestClient::Unauthorized
    @error = 'wrong Access Token'
    false
  end
end
