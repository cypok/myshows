require 'myshows/api'

module MyShows
  # Profile initialization is needed to gain access
  # to some functions of API
  class Profile

    # Login and md5-hashed password of
    # valid account on myshows.ru
    def initialize(login, password_md5)
      @api = MyShows::API.instance

      @api.authorize login, password_md5
    end

    # All active, delayed and cancelled shows
    # of current user
    def shows
      @api.user_shows
    end
  end
end
