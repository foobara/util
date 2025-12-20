RSpec.describe Foobara::Util do
  describe ".remove_blank" do
    it "removes blank values" do
      expect(described_class.remove_blank(a: 1, b: nil)).to eq(a: 1)
    end
  end

  describe ".symbolize_keys" do
    it "symbolizes keys" do
      expect(described_class.symbolize_keys(a: 1, b: 2)).to eq(a: 1, b: 2)
    end

    context "when it is not a hash but becomes one via #to_h" do
      before do
        stub_class "MyHash", Hash
      end

      it "symbolizes keys and returns a Hash" do
        h = MyHash.new
        h["a"] = 1

        symbolized_hash = described_class.symbolize_keys(h)

        expect(symbolized_hash).to eq(a: 1)
        expect(symbolized_hash.class).to be(Hash)
      end
    end
  end

  describe ".symbolize_keys!" do
    it "symbolizes keys" do
      h = { "a" => 1, "b" => 2 }

      described_class.symbolize_keys!(h)

      expect(h).to eq(a: 1, b: 2)
    end

    context "when it doesn't obey transform_keys!" do
      before do
        stub_class "MyHash", Hash do
          def transform_keys!(...) = self
        end
      end

      it "gives an argument error" do
        h = MyHash.new
        h["a"] = 1

        expect { described_class.symbolize_keys!(h) }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".all_symbolic_keys?" do
    it "returns true if all keys are symbols" do
      expect(described_class.all_symbolic_keys?(a: 1, b: 2)).to be(true)
      expect(described_class.all_symbolic_keys?(a: 1, b: 2, "c" => 3)).to be(false)
    end
  end
end
