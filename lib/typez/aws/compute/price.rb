require "typez/aws/compute/instance_type_mapping"
require "fileutils"

module Typez
  module AWS
    module Compute
      class Price
        URLS = %w(
          http://aws.amazon.com/ec2/pricing/pricing-on-demand-instances.json
          http://aws.amazon.com/ec2/pricing/ri-light-linux.json
          http://aws.amazon.com/ec2/pricing/ri-medium-linux.json
          http://aws.amazon.com/ec2/pricing/ri-heavy-linux.json
        )

        attr_reader :region, :hourly_rate, :upfront, :years

        def initialize(type, size, region, hourly_rate, upfront = 0, years = 0)
          @type = type
          @size = size
          @region = region
          @hourly_rate = hourly_rate
          @upfront = upfront
          @years = years
        end

        def monthly_rate
          calc_years = [years, 1].max
          ("%.02f" % [(upfront + (hourly_rate * 24 * 365.0 * calc_years)) / (calc_years * 12)]).to_f
        end

        def instance_type
          InstanceTypeMapping.api_name(@type, @size)
        end

        class << self
          def update!(cache_dir = default_cache_dir)
            require "net/http"
            if !File.directory?(cache_dir)
              logger.info "creating directory #{cache_dir}"
              FileUtils.mkdir_p(cache_dir)
            end
            URLS.each do |url|
              path = "#{cache_dir}/#{File.basename(url)}"
              logger.info "fetching #{url} to #{path}"
              body = Net::HTTP.get(URI(url))
              File.open("#{path}.tmp", "w") { |f| f.print(body) }
              FileUtils.mv("#{path}.tmp", path)
            end
          end

          def by_instance_type(cache_dir = default_cache_dir)
            all(cache_dir).inject({}) do |hash, price|
              hash[price.instance_type] ||= []
              hash[price.instance_type] << price
              hash
            end
          end

          def all(cache_dir = default_cache_dir)
            require "multi_json"
            paths = Dir.glob("#{cache_dir}/*.json")
            raise "no json files found. try running update! first?!?" if paths.empty?
            @all ||= paths.map do |path|
              from_json_attributes(MultiJson.load(File.read(path)))
            end.flatten
          end

          def fetched?(cache_dir = default_cache_dir)
            Dir.glob("#{cache_dir}/*.json").any?
          end

          def default_cache_dir
            File.expand_path("~/.typez")
          end

          def logger
            require "logger"
            @logger ||= Logger.new(STDOUT)
          end

          def from_json_attributes(attributes)
            prices = []
            attributes["config"]["regions"].each do |regions_hash|
              region = regions_hash["region"]
              region = "eu-west-1" if region == "eu-ireland"
              regions_hash["instanceTypes"].each do |type_hash|
                type = type_hash["type"]
                type_hash["sizes"].each do |size_hash|
                  size = size_hash["size"]
                  prices += from_json(type, size, region, size_hash["valueColumns"])
                end
              end
            end
            prices
          end

          def from_json(type, size, region, prices)
            out = []
            if one_year = price_from_name(prices, "yrTerm1Hourly")
              upfront = price_from_name(prices, "yrTerm1")
              out << new(type, size, region, one_year, upfront, 1)
            end
            if three_years = price_from_name(prices, "yrTerm3Hourly")
              upfront = price_from_name(prices, "yrTerm3")
              out << new(type, size, region, three_years, upfront, 3)
            end
            if value = price_from_name(prices, "linux")
              out << new(type, size, region, value)
            end
            out
          end

          def price_from_name(prices, name)
            price_hash = prices.select { |price| price["name"] == name }.first
            price_hash["prices"]["USD"].to_f if price_hash
          end
        end
      end
    end
  end
end
