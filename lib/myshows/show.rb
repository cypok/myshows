module MyShows
  autoload :Item, 'myshows/item'

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

    def episodes
      @api.show_episodes self
    end

    def episode(season_number, episode_number)
      episodes.detect {|e| e.season_number == season_number && e.episode_number == episode_number }
    end
  end
end
