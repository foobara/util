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

  describe ".start_with?" do
    subject { described_class.start_with?(large_array, small_array) }

    context "when size of large array is smaller than size of small array" do
      let(:large_array) { [1, 2, 3] }
      let(:small_array) { [1, 2, 3, 4, 5, 6, 7] }

      it { is_expected.to be(false) }
    end

    context "when large array starts with elements from small array" do
      let(:large_array) { [1, 2, 3, 4, 5, 6, 7] }
      let(:small_array) { [1, 2, 3, 4] }

      it { is_expected.to be(true) }
    end

    context "when elements in small array don't match those in large array" do
      let(:large_array) { [1, 2, 3, 4, 5, 6, 7] }
      let(:small_array) { [5, 6, 7, 8] }

      it { is_expected.to be(false) }
    end

    context "when first elements in small array match those in the large array but last elements don't match" do
      let(:large_array) { [1, 2, 3, 4, 5, 6, 7] }
      let(:small_array) { [1, 2, 8, 9] }

      it { is_expected.to be(false) }
    end

    context "when small array and large array are of the same size" do
      let(:large_array) { [1, 2, 3, 4] }
      let(:small_array) { [1, 2, 3, 4] }

      it { is_expected.to be(false) }
    end
  end
end
