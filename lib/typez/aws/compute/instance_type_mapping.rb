require "typez/aws/compute"

module Typez::AWS::Compute::InstanceTypeMapping
  TYPE_MAPPING = {
    "stdODI" => "m1",
    "stdResI" => "m1",
    "secgenstdODI" => "m3",
    "secgenstdResI" => "m3",
    "uODI" => "t1",
    "uResI" => "t1",
    "hiMemODI" => "m2",
    "hiMemResI" => "m2",
    "hiCPUODI" => "c1",
    "hiCPUResI" => "c1",
    "clusterComputeI" => "cc2",
    "clusterCompResI" => "cc2",
    "clusterHiMemODI" => "cr1",
    "clusterHiMemResI" => "cr1",
    "clusterGPUI" => "cg1",
    "clusterGPUResI" => "cg1",
    "hiIoODI" => "hi1",
    "hiIoResI" => "hi1",
    "hiStoreODI" => "hs1",
    "hiStoreResI" => "hs1"
  }

  SIZE_MAPPING = {
    "sm" => "small",
    "med" => "medium",
    "lg" => "large",
    "xl" => "xlarge",
    "xxl" => "2xlarge",
    "u" => "micro",
    "xxxxl" => "4xlarge",
    "xxxxxxxxl" => "8xlarge"
  }

  class << self
    def api_name(type, size)
      "#{TYPE_MAPPING.fetch(type)}.#{SIZE_MAPPING.fetch(size)}"
    end
  end
end
