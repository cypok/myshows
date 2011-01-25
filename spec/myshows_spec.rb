require 'myshows'
require 'myshows/show'
require 'myshows/episode'

describe MyShows do
  TBBT = 'The Big Bang Theory'

  describe MyShows::Profile do
    before :all do
      @profile = MyShows::Profile.new 'demo', 'fe01ce2a7fbac8fafaed7c982a04e229'
    end

    it "should return user shows" do
      @profile.shows.map(&:title).should include TBBT
    end
  end

  describe MyShows::Search do
    before :all do
      @search = MyShows::Search.new
    end

    it "should find popular show" do
      found = @search.show TBBT
      found.map(&:title).should == [TBBT]
    end

    it "should not find unknown show" do
      found = @search.show 'Some unkown show'
      found.should == []
    end
  end

  describe MyShows::Show do
    before :all do
      @show = MyShows::Search.new.show(TBBT).first
    end

    it "should have title" do
      @show.title.should == TBBT
    end

    it "should have episodes" do
      @show.episodes.should have_at_least(10).items
    end

    it "should find episode by season and episode number" do
      e = @show.episode(1, 2)
      e.season_number.should == 1
      e.episode_number.should == 2
    end
  end

  describe MyShows::Episode do
    before :all do
      @episode = MyShows::Search.new.show(TBBT).first.episode(1,1)
    end

    it "should be connected with show" do
      @episode.show.title.should == TBBT
    end

    it "should have title, season and episode number" do
      @episode.title.should == "Pilot"
      @episode.season_number.should == 1
      @episode.episode_number.should == 1
    end

    it "should be checkable" do
      @episode.check!
    end

    it "should be uncheckable" do
      @episode.uncheck!
    end
  end
end
