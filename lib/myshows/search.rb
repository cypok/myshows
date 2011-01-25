require 'myshows/api'

module MyShows
  # Tools for searching over whole base of myshows.ru
  class Search
    def initialize
      @api = MyShows::API.instance
    end

    # Simple show search by its name,
    # number of results is limited
    def show(name)
      @api.search_show name
    end
  end
end
