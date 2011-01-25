module MyShows
  autoload :API, 'myshows/api'

  # Tools for searching over whole base
  class Search
    def initialize
      @api = MyShows::API.instance
    end

    def show(name)
      @api.search_show name
    end
  end
end
