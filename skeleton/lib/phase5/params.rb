require 'uri'

module Phase5
  class Params
    # merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    def initialize(req, route_params = {})
      @params = route_params
      parse_www_encoded_form(req.query_string)
      parse_www_encoded_form(req.body)
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # returns deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # returns
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      return if www_encoded_form.nil?

      params_arr = URI::decode_www_form(www_encoded_form, enc=Encoding::UTF_8)
      params_arr.each do |item|

        keys = parse_key(item[0])

        key = {}
        key[keys[0]] = {}
        holder = key[keys[0]]

        i = 1
        while i < keys.size
          holder[keys[i]] = {}
          break if i == keys.size - 1
          holder = holder[keys[i]]

          i += 1
        end

        values = parse_key(item[1])

        if keys.size == 1
          values.each do |value|
            holder[keys[0]] = value
          end

          @params.merge!(key[keys[0]])
        else
          values.each do |value|
            holder[keys[i]] = value
          end

          @params.merge!(key)
        end
      end

      return
    end

    # returns an array
    # user[address][street] returns ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
