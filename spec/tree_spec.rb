RSpec.describe Foobara::Util do
  let(:pairs) do
    [
      ["duck", nil],
      ["atomic_duck", "duck"],
      ["symbol", "atomic_duck"],
      ["number", "atomic_duck"],
      ["integer", "number"],
      ["float", "number"],
      ["big_decimal", "number"],
      ["string", "atomic_duck"],
      ["email", "string"],
      ["date", "atomic_duck"],
      ["datetime", "atomic_duck"],
      ["boolean", "atomic_duck"],
      ["model", "atomic_duck"],
      ["entity", "model"],
      ["duckture", "duck"],
      ["array", "duckture"],
      ["tuple", "array"],
      ["associative_array", "duckture"],
      ["attributes", "associative_array"]
    ]
  end
  let(:to_parent) do
    proc do |object|
      parent_name = object.last
      pairs.find { |pair| pair.first == parent_name }
    end
  end
  let(:to_name) { :first }

  describe "#print_tree" do
    let(:io) { StringIO.new }

    it "prints the structured tree" do
      described_class.print_tree(pairs, io:)
      expect(io.string).to include("duck")
    end
  end

  describe Foobara::Util::Tree do
    describe "#to_s" do
      context "when tree is built with simple pairs" do
        let(:tree) do
          described_class.new(pairs, to_parent)
        end

        it "prints the structured tree" do
          expect(tree.to_s(:first)).to include("duck")
        end

        context "with no to_name" do
          it "uses to_s" do
            expect(tree.to_s).to include("duck")
          end
        end

        context "with a block for to_name" do
          it "uses the block" do
            expect(tree.to_s(&:first)).to include("duck")
          end
        end
      end
    end
  end
end
