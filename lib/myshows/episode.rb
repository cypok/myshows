module MyShows
  autoload :Item, 'myshows/item'

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

    def check!
      @api.check_episode self
    end

    def uncheck!
      @api.uncheck_episode self
    end
  end
end
