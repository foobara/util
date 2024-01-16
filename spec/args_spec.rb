RSpec.describe Foobara::Util do
  describe ".args_and_opts_to_opts" do
    subject { described_class.args_and_opts_to_opts(args, opts) }

    let(:args) { [] }
    let(:opts) { {} }

    context "with no args" do
      it { is_expected.to be(opts) }
    end

    context "with one arg" do
      let(:args) { ["arg"] }

      context "with no opts" do
        it { is_expected.to eq("arg") }
      end
    end
  end
end
