require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      req.cookies.each do |cookie|
        if cookie.name == "_rails_lite_app"
          value = cookie.value
          @cookie_value = JSON.parse(value)
          return
        end
      end

      @cookie_value = {}
    end

    def [](key)
      @cookie_value[key]
    end

    def []=(key, val)
      @cookie_value[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res_cookie = WEBrick::Cookie.new("_rails_lite_app", @cookie_value.to_json)
      res.cookies << res_cookie
    end
  end
end
