RSpec.describe Foobara::Util do
  describe ".args_and_opts_to_opts" do
    subject { described_class.args_and_opts_to_opts(args, opts) }

    let(:args) { [] }
    let(:opts) { {} }

    context "when args is a hash and so is opts" do
      let(:args) { [{ a: 1, b: 2 }] }
      let(:opts) { { c: 3, d: 4 } }

      it { is_expected.to eq(a: 1, b: 2, c: 3, d: 4) }
    end

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

  describe ".args_and_opts_to_args" do
    subject { described_class.args_and_opts_to_args(args, opts) }

    context "when no args" do
      let(:args) { [] }

      context "when no opts" do
        let(:opts) { nil }

        it { is_expected.to eq([]) }
      end

      context "when opts" do
        let(:opts) { { baz: :baz } }

        it { is_expected.to eq([{  baz: :baz }]) }
      end
    end

    context "when arg is nil" do
      let(:args) { [nil] }

      context "when no opts" do
        let(:opts) { nil }

        it { is_expected.to eq([nil]) }
      end

      context "when opts" do
        let(:opts) { { baz: :baz } }

        it { is_expected_to_raise(ArgumentError) }
      end
    end

    context "when 1 arg" do
      let(:args) { [{ foo: :bar }] }

      context "when no opts" do
        let(:opts) { nil }

        it { is_expected.to eq([{ foo: :bar }]) }
      end

      context "when opts" do
        let(:opts) { { baz: :baz } }

        it { is_expected.to eq([{ foo: :bar, baz: :baz }]) }
      end
    end
  end
end
