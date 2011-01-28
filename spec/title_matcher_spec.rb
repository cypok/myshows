require 'myshows'

describe MyShows::TitleMatcher do
  before :all do
    @titles = <<-END
V (2009)
Star Wars: The Clone Wars (2008)
Over There (US)
South Park
Lost
How I Met Your Mother
The IT Crowd
Due South (1994)
The Big Bang Theory
Life on Mars (UK)
Lie to Me
Avatar: The Last Airbender
FlashForward
Desperate Housewifes
    END
    @titles = @titles.split "\n"

    @matcher = MyShows::TitleMatcher.new @titles
  end

  it "should find nothing" do
    match("Unknown series").should be_empty
  end

  it "should simply find" do
    match("Lost").should == ["Lost"]
  end

  it "should ingore year of series start" do
    match("V").should == ["V (2009)"]
  end

  it "should ingore country of series creation" do
    match("Over There").should == ["Over There (US)"]
  end

  it "should ignore all but letters" do
    match("Star Wars The Clone Wars").should == ["Star Wars: The Clone Wars (2008)"]
  end

  it "should find ambiguous titles" do
    match("South").should == ["South Park", "Due South (1994)"]
  end

  it "should find separeted title" do
    match("Flash Forward").should == ["FlashForward"]
  end

  it "should find joined title" do
    match("lietome").should == ["Lie to Me"]
  end

  it "should find some part of title in src" do
    match("Avatar").should == ["Avatar: The Last Airbender"]
  end

  it "should find abbreviated title" do
    match("TBBT").should == ["The Big Bang Theory"]
  end

  it "should find title with extra article" do
    match("Life on a Mars").should == ["Life on Mars (UK)"]
  end

  it "should find title without article" do
    match("IT Crowd").should == ["The IT Crowd"]
  end

  it "should find title with wrong article" do
    match("An IT Crowd").should == ["The IT Crowd"]
  end

  protected

  def match(src)
    @titles.values_at *@matcher.match(src)
  end
end
