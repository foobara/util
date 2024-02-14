RSpec.describe Foobara::Util do
  describe ".array" do
    context "when already an array" do
      it "returns it" do
        a = [1, 2]
        expect(described_class.array(a)).to be(a)
      end
    end
  end

  describe ".power_set" do
    it "returns the power set" do
      expect(described_class.power_set([1, 2, 3])).to contain_exactly(
        [],
        [1], [2], [3],
        [1, 2], [1, 3], [2, 3],
        [1, 2, 3]
      )
    end
  end

  describe ".all_blank_or_false?" do
    subject { described_class.all_blank_or_false?(array) }

    context "when all empty nil or false" do
      let(:array) do
        [
          nil,
          false,
          {},
          [],
          ""
        ]
      end

      it { is_expected.to be(true) }
    end
  end
end
