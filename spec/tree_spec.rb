RSpec.describe Foobara::Util do
  let(:pairs) do
    [
      ["duck", nil],
      %w[atomic_duck duck],
      %w[symbol atomic_duck],
      %w[number atomic_duck],
      %w[integer number],
      %w[float number],
      %w[big_decimal number],
      %w[string atomic_duck],
      %w[email string],
      %w[date atomic_duck],
      %w[datetime atomic_duck],
      %w[boolean atomic_duck],
      %w[model atomic_duck],
      %w[entity model],
      %w[duckture duck],
      %w[array duckture],
      %w[tuple array],
      %w[associative_array duckture],
      %w[attributes associative_array]
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
