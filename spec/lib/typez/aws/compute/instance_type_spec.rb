require "spec_helper"
require "typez/aws/compute/instance_type"

describe "Typez::AWS::Compute::InstanceType" do
  subject(:clazz) { Typez::AWS::Compute::InstanceType }

  describe "#from_html" do
    let(:html) { FIXTURES_PATH.join("instance_types.html").read }
    subject(:instance_types) { clazz.from_html(html) }

    it { should be_kind_of(Array) }
    it { subject.count.should eq(17) }

    # uncomment this to re-write config
    xit "should dump the instance types" do
      require "yaml"
      path = PROJECT_ROOT.join("config/aws_instance_types.yml")
      File.open(path, "w") { |f| f.puts(YAML.dump(subject.map(&:attributes))) }
    end

    describe "#all" do
      subject(:all) { clazz.all }

      it { should be_kind_of(Array) }

      describe "#first" do
        subject(:first) { all.first }

        it { subject.type.should eq("m1.small") }
      end
    end

    describe "#first" do
      subject(:first) { instance_types.first }

      it { subject.family.should eq("General purpose") }
      it { subject.type.should eq("m1.small") }
      it { subject.should be_is_32bit }
      it { subject.should be_is_64bit }
      it { subject.vcpu.should eq(1) }

      it { subject.should_not be_ebs_optimizable }

      it { subject.attributes.should be_kind_of(Hash) }
    end

    describe "#third" do
      subject(:third) { instance_types.at(2) }

      it { subject.family.should eq("General purpose") }
      it { subject.type.should eq("m1.large") }
      it { subject.should_not be_is_32bit }
      it { subject.should be_is_64bit }
      it { subject.vcpu.should eq(2) }
      it { subject.ecu.should eq(4.0) }
      it { subject.memory.should eq(7.5) }
      it { subject.storage.should eq("2 x 420") }
      it { subject.storage_disks.should eq(2) }
      it { subject.storage_per_disk.should eq(420) }
    end

    it { subject.at(0).should_not be_ebs_optimizable }
    it { subject.at(2).should be_ebs_optimizable }


    it { subject.at(14).storage_disks.should eq(24) }
    it { subject.at(14).storage_per_disk.should eq(2048) }


    it { subject.at(14).should_not be_ebs_only }
    it { subject.at(15).should be_ebs_only }


    it { subject.at(14).should_not be_ssd }

    it { subject.at(13).storage.should eq("2 x 1,024 SSD") }
    it { subject.at(13).should be_ssd }

    describe "network" do
      it { subject.at(0).network_performance.should eq("Low") }
      it { subject.at(16).network_performance.should eq("10 Gigabit") }
    end
  end

  describe "#cast_storage" do
    it { Typez::AWS::Compute::InstanceType.cast_storage("1 x 102").should eq(per_disk: 102, disks: 1) }
    it { Typez::AWS::Compute::InstanceType.cast_storage("24 x 2,048*4").should eq(per_disk: 2048, disks: 24) }
  end
end
