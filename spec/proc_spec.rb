RSpec.describe Foobara::Util do
  describe ".remove_arity_check" do
    let(:checkless_proc) { described_class.remove_arity_check(lambda) }

    context "when lambda takes an argument" do
      let(:lambda) { ->(x) { x } }

      it "functions without an argument" do
        expect(checkless_proc.call).to be_nil
      end

      it "functions with arity match" do
        expect(checkless_proc.call(1)).to eq(1)
      end

      it "ignores extra args" do
        expect(checkless_proc.call(1, 2)).to eq(1)
      end
    end

    context "when lambda takes no arguments" do
      let(:lambda) { -> { 1 } }

      it "functions without an argument" do
        expect(checkless_proc.call).to be 1
      end

      it "ignores extra args" do
        expect(checkless_proc.call(100, 200)).to eq(1)
      end
    end
  end
end
