require 'myshows/api'
require 'myshows/title_matcher'

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

    # Smart search of one of user shows by title
    def show(title)
      found = shows.values_at *matcher.match(title)
      case found.count
      when 0
        raise MyShows::Error.new "show with title \"#{title}\" was not found"
      when 1
        found.first
      else
        raise MyShows::Error.new "ambiguous title \"#{title}\" corresponds to shows #{found.map {|s| %Q["#{s}"]} * ', '}"
      end
    end

    protected

    def matcher
      @matcher ||= MyShows::TitleMatcher.new shows.map(&:title)
    end
  end
end
