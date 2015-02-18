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

  hash = {}
  [["user[address][street]", "main"], ["user[address][zip]", "89436"]].each do |arr|
    parsed_arr = parse_key(arr[0])
    parsed_arr << arr[1]
    hash = hash.deep_merge(nested_hash(parsed_arr))
  end
  puts hash
