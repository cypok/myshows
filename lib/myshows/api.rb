require 'rubygems'
require 'httparty'
require 'crack/json'
require 'memoize'
require 'singleton'

JSON = Crack::JSON

module MyShows
  autoload :Show, 'myshows/show'
  autoload :Episode, 'myshows/episode'

  class API
    include Singleton

    include HTTParty
    base_uri 'http://api.myshows.ru'

    include Memoize

    def initialize
      %w{search user_shows show_episodes}.each {|m| memoize m }
    end

    def authorize(login, password)
      res = get '/profile/login', :login => login, :password => password
      error "login or password is incorrect while authorization" if res.code == 403
      error "unknown error while authorization" if res.code != 200

      self.class.cookies.add_cookies res.headers["set-cookie"]
    end

    # Returns checked episode
    #def check(name, season_number, episode_number)
      #shows = search name, :only_user => true
      #error "could not find show \"#{name}\" or it is not marked as 'watching'" if shows.count == 0
      #error "ambiguous name \"#{name}\", looks like #{shows.take(2) * ', '}" if shows.count > 1

      #show = shows.first
      #episodes = show_episodes show
      #episode = episodes.detect { |e| e.season_number == season_number && e.episode_number == episode_number }
      #error "could not find episode #{season_number}x#{episode_number} of show #{show}" if episode.nil?

      #check_episode episode

      #episode
    #end

    # Returns all user shows
    def user_shows
      res = get '/profile/shows/'
      error "authorization problems while getting user shows" if res.code == 401
      error "unknown error while getting user shows" if res.code != 200

      json2shows res.body
    end

    # Returns array of found shows
    def search_show(name)
      res = get '/shows/search/', :q => name
      return [] if res.code == 404
      error "unknown error while searching show \"#{name}\"" if res.code != 200

      found_shows = json2shows res.body
    end

    # Returns episodes of given show
    def show_episodes(show)
      res = get "/shows/#{show.id}"
      error "could not find show #{show} while getting its episodes" if res.code == 404
      error "unknown error while getting episodes of show #{show}" if res.code != 200

      json2episodes res.body, show
    end

    # Checks given episode as watched
    def check_episode(episode)
      res = get "/profile/episodes/check/#{episode.id}"
      error "authorization problems while checking episode #{episode}" if res.code == 401
      error "unknown error while checking episode #{episode}" if res.code != 200

      episode
    end

    # Unchecks given episode as watched
    def uncheck_episode(episode)
      res = get "/profile/episodes/uncheck/#{episode.id}"
      error "authorization problems while unchecking episode #{episode}" if res.code == 401
      error "unknown error while unchecking episode #{episode}" if res.code != 200

      episode
    end

    protected

    def json2shows(json)
      JSON.parse(json).map {|id, data| MyShows::Show.new id, data }
    end

    def json2episodes(json, show)
      JSON.parse(json)['episodes'].map {|id, data| MyShows::Episode.new id, data, show }
    end

    def error(msg)
      raise MyShows::Error.new msg
    end

    private

    def get(url, opts = {})
      #puts "GET url: " + url + " opts: " + make_options(opts).inspect
      self.class.get url, make_options(opts)
    end

    def post(url, opts = {})
      self.class.post url, make_options(opts)
    end

    def make_options(opts = {})
      {:query => opts}
    end
  end
end
