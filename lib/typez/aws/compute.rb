require "nokogiri"

module Typez
  module AWS
    module Compute
      class << self
        def instance_types
          [1]
        end
      end
    end
  end
end
