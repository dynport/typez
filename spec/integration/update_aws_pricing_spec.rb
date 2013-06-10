require "spec_helper"
require "typez/aws/compute/price"

describe "Update AWS pricing spec", :integration do
  let(:clazz) { Typez::AWS::Compute::Price }
  let(:cache_dir) { PROJECT_ROOT.join("tmp/typez") }

  before do
    clazz.logger.level = Logger::WARN
  end

  it "should store the correct files" do
    Dir.glob("#{cache_dir}/*.json").each { |path| FileUtils.rm(path) }
    Typez::AWS::Compute::Price.update!(cache_dir)

    files = Dir.glob("#{cache_dir}/*.json")
    files.count.should eq(4)
    prices = clazz.all(cache_dir)
    prices.count.should > 700

    hashed_prices = clazz.by_instance_type(cache_dir)
    hashed_prices.keys.count.should > 10
  end
end
