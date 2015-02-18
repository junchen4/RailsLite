require 'active_support'
require 'uri'

#recursive implementation to create nested hash
def nested_hash(arr)
  return arr.first if arr.count == 1
  h = {}
  key = arr.shift
  h[key] = nested_hash(arr)
  h
end

def parse_key(key)
  str_arr = key.split(/[\[\]]/).compact
  str_arr.delete("")
  str_arr
end

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
  puts parse_www_encoded_form("")
