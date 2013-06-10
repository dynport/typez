require "spec_helper"
require "multi_json"
require "typez/aws/compute/price"

describe "Typez::AWS::Compute::Price" do
  subject(:clazz) { Typez::AWS::Compute::Price }
  it { should_not be_nil }

  describe "#from_json_attributes" do
    let(:json) { FIXTURES_PATH.join("pricing-on-demand-instances.json").read }

    subject(:prices) { clazz.from_json_attributes(MultiJson.load(json)) }
    it { should be_kind_of(Array) }
    it { subject.count.should eq(104) }

    describe "#first" do
      subject(:first) { prices.first }

      it { should_not be_nil }
      it { subject.instance_type.should be_kind_of(String) }
      it { subject.instance_type.should eq("m1.small") }
      it { subject.region.should be_kind_of(String) }
    end

    it { subject.map(&:instance_type).should be_kind_of(Array) }
  end

  describe "#monthly_rate" do
    describe "without upfront pricing" do
      subject(:price) { clazz.new("type", "size", "region", 1.0, 0, 0) }
      it { price.monthly_rate.should eq(730.0) }
    end

    describe "with upfront payment" do
      subject(:price) { clazz.new("type", "size", "region", 0.5, 100, 3) }
      it { price.monthly_rate.should eq(367.78) }
    end
  end

  describe "#all" do
    it "raises an error when no json files found" do
      lambda do
        subject.all("/will/not/exist")
      end.should raise_error(/no json files found/)
    end
  end
end

