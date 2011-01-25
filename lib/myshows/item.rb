module MyShows
  class Item
    attr_reader :id

    def initialize(id, data)
      @api = MyShows::API.instance

      @id = id
      @data = data
    end

    def method_missing(name, *args)
      return super(name, *args) if args.count > 0

      # convert to camel case
      cc_name = name.to_s.gsub(/_[a-z]/) {|a| a.upcase }.gsub '_', ''

      @data[cc_name] or super(name)
    end

    def ==(other)
      self.class == other.class && self.id == other.id
    end
  end
end
