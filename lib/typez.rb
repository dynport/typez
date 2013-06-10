require "typez/version"

module Typez
  class << self
    def cache_dir
      @cache_dir || File.expand_path("~/.typez")
    end
  end
end
