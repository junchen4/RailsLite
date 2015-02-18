require 'uri'
require 'active_support' #for deep_merge function
require 'byebug'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      req.query_string = "" if req.query_string.nil?
      req.body = "" if req.body.nil?
      @params = parse_www_encoded_form(req.query_string)
      @params = @params.merge(parse_www_encoded_form(req.body))

      @params = @params.merge(route_params)
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      hash = {}
      decoded_arr = URI.decode_www_form(www_encoded_form)
      decoded_arr.each do |arr|
        parsed_arr = parse_key(arr[0])
        parsed_arr << arr[1]
        hash.deep_merge!(nested_hash(parsed_arr))
      end
      hash
    end

    #recursive implementation to create nested hash
    def nested_hash(arr)
      return arr.first if arr.count == 1
      h = {}
      key = arr.shift
      h[key] = nested_hash(arr)
      h
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      str_arr = key.split(/[\[\]]/).compact
      str_arr.delete("")
      str_arr
    end
  end
end
