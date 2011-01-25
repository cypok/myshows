$: << File.expand_path(File.dirname(__FILE__))

module MyShows
  autoload :Profile, 'myshows/profile'
  autoload :Search, 'myshows/search'

  class Error < StandardError; end
end
