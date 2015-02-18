require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      cookie = req.cookies.select {|cookie| cookie.name == '_rails_lite_app'}.first
      !cookie.nil? ? @cook_hash = JSON.parse(cookie.value) : @cook_hash = {}
    end

    def [](key)
      @cook_hash[key]
    end

    def []=(key, val)
      @cook_hash[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', @cook_hash.to_json)
    end
  end
end
