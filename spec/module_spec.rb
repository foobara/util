RSpec.describe Foobara::Util do
  describe ".const_get_up_hierarchy" do
    subject { described_class.const_get_up_hierarchy(mod, name) }

    context "when anonymous class" do
      let(:mod) { Class.new(String) }
      let(:name) { :Hash }

      it { is_expected.to be(Hash) }

      context "when bad constant" do
        let(:name) { :NoSuchConstant }

        it { is_expected_to_raise(NameError, "uninitialized constant NoSuchConstant") }
      end
    end
  end
end
