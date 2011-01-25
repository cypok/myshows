require 'myshows/item'

module MyShows
  # Provides such methods:
  # title
  # episode_number
  # season_number
  # short_name
  # air_date
  # sequence_number
  # production_number
  # image
  # tvrage_link
  class Episode < Item
    attr_reader :show

    def initialize(id, data, show)
      super(id, data)

      @show = show

      [:id, :show, :title, :season_number, :episode_number].each do |f|
        raise ArgumentError.new("#{f} could not be nil") if send(f).nil?
      end
    end

    def to_s
      "#{show} - #{season_number}x#{episode_number} - #{title}"
    end

    # Check episode as 'watched',
    # requires authorization via Profile
    def check!
      @api.check_episode self
    end

    # Check episode as 'unwatched',
    # requires authorization via Profile
    def uncheck!
      @api.uncheck_episode self
    end
  end
end
