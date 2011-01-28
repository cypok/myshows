module MyShows
  class TitleMatcher
    # You could extend this list
    MATCHING_PROCS = [
      # simple
      proc {|src, title| src == title },

      # flash forward => FlashForward
      # lietome => Lie to Me
      proc {|src, title| src.gsub(' ', '') == title.gsub(' ', '') },

      # tbbt => The Big Bang Theory
      proc {|src, title| src == title.split.map{|w| w[0,1]} * '' },

      # avatar => Avatar: The Last Airbender
      proc {|src, title| title.split.include? src },

      # house m d => House
      proc {|src, title| src.split.include? title },
    ]

    def initialize(titles)
      @titles = titles.map {|s| strip(s)}
      @titles_wo_articles = @titles.map {|t| wo_articles(t) }
    end

    # Tries to find title closest to src,
    # returns list of indexes of titles
    def match(src)
      matched = []

      src = strip(src)


      MATCHING_PROCS.each do |matcher|
        @titles.each_with_index do |title, i|
          matched << i if matcher.call(src, title)
        end
        return matched unless matched.empty?
      end

      src_wo_articles = wo_articles(src)
      MATCHING_PROCS.each do |matcher|
        @titles_wo_articles.each_with_index do |title_wo_articles, i|
          matched << i if matcher.call(src_wo_articles, title_wo_articles)
        end
        return matched unless matched.empty?
      end

      []
    end

    private

    def strip(s)
      s.clone.downcase.
              gsub(/\(\d{4}\)/, '').        # to clean "V (2009)"
              gsub(/\([A-Za-z]{2}\)/, '').  # to clean "Bless This House (US)"
              gsub(/[^A-Za-z0-9]/, ' ').    # to clean "Star Wars: the Clone Wars"
              gsub(/  +/, ' ').strip        # remove extra spaces
    end

    def wo_articles(str)
      str.split.reject {|w| w =~ /^the|an?$/ } * ' '
    end
  end
end
