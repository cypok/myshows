require 'myshows/item'

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

    # Returns episode by season and episode number
    def episode(season_number, episode_number)
      episodes.detect {|e| e.season_number == season_number && e.episode_number == episode_number }
    end
  end
end
