require "typez"
require "typez/aws/compute/price"
require "typez/aws/compute/instance_type"

module Typez
  module AWS
    module Compute
      class InstancePrice
        attr_reader :instance_type, :prices

        def initialize(instance_type, prices)
          @instance_type = instance_type
          @prices = prices.sort_by(&:monthly_rate)
        end

        def max_price
          @max_price ||= @prices.last
        end

        def min_price
          @min_price ||= @prices.first
        end

        def savings
          1 - (min_price.monthly_rate / max_price.monthly_rate)
        end

        class << self
          def for_region(region, cache_dir = Typez.cache_dir)
            prices_hash = Price.by_instance_type(cache_dir)
            InstanceType.all.map do |type|
              prices = prices_hash[type.type].select do |p|
                p.region == region && p.hourly_rate > 0 
              end.sort_by(&:monthly_rate)
              new(type, prices)
            end
          end
        end
      end
    end
  end
end
