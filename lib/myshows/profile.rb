module MyShows
  autoload :API, 'myshows/api'

  class Profile

    def initialize(login, password)
      @api = MyShows::API.instance

      @api.authorize login, password
    end

    def shows
      @api.user_shows
    end
  end
end
