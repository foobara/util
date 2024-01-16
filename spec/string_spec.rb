RSpec.describe Foobara::Util do
  describe ".underscore" do
    context "when symbol" do
      it "still works" do
        expect(described_class.underscore(:ClassMethods)).to eq("class_methods")
      end
    end
  end
end
