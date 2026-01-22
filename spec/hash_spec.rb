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

  context "when sorting" do
    let(:unsorted_hash) do
      # generated with: (97..122).to_a.shuffle.to_h{|v|[v.chr.to_sym,v - 96]}
      {
        c: 3,
        o: 15,
        m: 13,
        x: 24,
        u: 21,
        e: 5,
        w: 23,
        g: 7,
        s: 19,
        f: 6,
        a: 1,
        y: 25,
        d: 4,
        q: 17,
        z: 26,
        r: 18,
        i: 9,
        n: 14,
        b: 2,
        l: 12,
        h: 8,
        v: 22,
        t: 20,
        k: 11,
        j: 10,
        p: 16
      }
    end

    let(:sorted_hash) do
      {
        a: 1,
        b: 2,
        c: 3,
        d: 4,
        e: 5,
        f: 6,
        g: 7,
        h: 8,
        i: 9,
        j: 10,
        k: 11,
        l: 12,
        m: 13,
        n: 14,
        o: 15,
        p: 16,
        q: 17,
        r: 18,
        s: 19,
        t: 20,
        u: 21,
        v: 22,
        w: 23,
        x: 24,
        y: 25,
        z: 26
      }
    end

    describe ".sort_by_keys" do
      it "sorts keys" do
        result = described_class.sort_by_keys(unsorted_hash)
        expect(result).to eq(sorted_hash)
        expect(result).to_not be(unsorted_hash)
      end
    end

    describe ".sort_by_keys!" do
      it "sorts keys in place" do
        result = described_class.sort_by_keys!(unsorted_hash)
        expect(result).to eq(sorted_hash)
        expect(result).to be(unsorted_hash)
      end
    end
  end
end
