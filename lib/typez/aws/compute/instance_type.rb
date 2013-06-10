module Typez
  module AWS
    module Compute
      class InstanceType
        SRC_URL = "http://aws.amazon.com/ec2/instance-types/"
        attr_reader :attributes

        class << self
          def all
            require "yaml"
            YAML.load_file(instance_type_config_path).map { |a| new(a) }
          end

          def instance_type_config_path
            File.expand_path("../../../../../config/aws_instance_types.yml", __FILE__)
          end

          def from_html(html)
            doc = Nokogiri::HTML(html)
            if table = doc.search("table").first
              table.search("./tr").map do |row|
                family, type, arch, vcpu, ecu, memory, storage, ebs_optimizable, network_performance = row.search("td").map { |td| td.inner_text.strip }
                atts = {
                  family: family, type: type, arch: arch, vcpu: cast_int(vcpu),
                  ecu: cast_float(ecu), memory: cast_float(memory),
                  storage: remove_legend(storage),
                  ebs_optimizable: ebs_optimizable,
                  network_performance: remove_legend(network_performance)
                }

                InstanceType.new(atts)
              end
            end
          end

          def remove_legend(raw)
            raw.gsub(/\*\d+$/, "").gsub(/\s+/, " ").strip
          end

          def cast_storage(raw)
            if raw.match(/^(\d+) x ([\d\,]+)/)
              { disks: cast_int($1), per_disk: cast_int($2.gsub(",", "")) }
            else
              {}
            end
          end

          def cast_int(value)
            Integer(value) rescue nil
          end

          def cast_float(value)
            Float(value) rescue nil
          end
        end

        def initialize(attributes)
          @attributes = attributes
        end

        [:family, :type, :arch, :vcpu, :ecu, :memory, :storage, :ebs_optimizable, :network_performance].each do |name|
          define_method(name) do
            @attributes[name]
          end
        end

        def storage_per_disk
          storage_attributes[:per_disk]
        end

        def ebs_optimizable?
          ebs_optimizable == "Yes"
        end

        def ebs_only?
          storage.include?("EBS only")
        end

        def ssd?
          storage.include?("SSD")
        end

        def storage_disks
          storage_attributes[:disks]
        end

        def storage_attributes
          @storage_attributes ||= self.class.cast_storage(storage)
        end

        def is_64bit?
          arch.include?("64-bit")
        end

        def is_32bit?
          arch.include?("32-bit")
        end
      end
    end
  end
end
