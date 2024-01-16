RSpec.describe Foobara::Util do
  describe ".remove_blank" do
    it "removes blank values" do
      expect(described_class.remove_blank(a: 1, b: nil)).to eq(a: 1)
    end
  end
end
