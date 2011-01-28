require 'myshows/item'
require 'myshows/title_matcher'

module MyShows
  # Provides such methods:
  # title
  # ru_title
  # rating
  # country
  # started
  # ended
  # runtime
  # voted
  # year
  # genres
  # status
  # watching
  # imdb_id
  # tvrage_id
  # kinopoisk_id

  class Show < Item
    def initialize(id, data)
      super(id, data)

      [:id, :title].each do |f|
        raise ArgumentError.new("#{f} could not be nil") if send(f).nil?
      end
    end

    def to_s
      title
    end

    # Returns all episodes
    def episodes
      @api.show_episodes self
    end

    # Returns episode by title (smart search) or by season and episode number
    def episode(*args)
      if args.first.is_a? String
        episode_by_title *args
      else
        episode_by_numbers *args
      end
    end

    protected

    def episode_by_title(title)
      found = episodes.values_at *matcher.match(title)
      case found.count
      when 0
        raise MyShows::Error.new "episode with title \"#{title}\" was not found in show #{self}"
      when 1
        found.first
      else
        raise MyShows::Error.new "ambiguous title \"#{title}\" corresponds to episodes #{found.map {|s| %Q["#{s}"]} * ', '}"
      end
    end

    def matcher
      @matcher ||= MyShows::TitleMatcher.new episodes.map(&:title)
    end

    def episode_by_numbers(season_number, episode_number)
      episodes.detect {|e| e.season_number == season_number && e.episode_number == episode_number }.tap do |e|
        if e.nil?
          raise MyShows::Error.new "episode with number #{season_number}x#{episode_number} was not found in show #{self}"
        end
      end
    end
  end
end
