require "spec_helper"
require "typez/aws/compute/instance_price"

describe "Typez::AWS::Compute::InstancePrize", :wip do
  subject(:clazz) { Typez::AWS::Compute::InstancePrice }
  it { should_not be_nil }

  describe "#for_region" do
    subject(:prices) { clazz.for_region("eu-west-1", FIXTURES_PATH.to_s) }

    it { should be_kind_of(Array) }
    it { should_not be_empty }

    describe "#first" do
      subject(:first) { prices.select { |p| p.instance_type.type == "m1.medium" }.first }
      it { should_not be_nil }
      it { subject.instance_type.type.should be_kind_of(String) }
      it { subject.instance_type.type.should eq("m1.medium") }
      it { subject.prices.should be_kind_of(Array) }
      it { subject.prices.count.should eq(7) }

      it { subject.min_price.should_not be_nil }
      it { subject.min_price.monthly_rate.should eq(39.83) }
      it { subject.max_price.should_not be_nil }
      it { subject.max_price.monthly_rate.should eq(94.9) }

      it { subject.savings.should eq(0.5802950474183352) }
    end

    describe "without savings" do
      subject(:price) { prices.select { |p| p.instance_type.type == "cg1.4xlarge" }.first }
      it { subject.savings.should eq(0) }
    end
  end
end
