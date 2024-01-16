RSpec.describe Foobara::Util do
  describe ".make_class" do
    context "when parent modules don't exist" do
      it "raises an error" do
        expect {
          described_class.make_class("A::B")
        }.to raise_error(described_class::ParentModuleDoesNotExistError)
      end
    end
  end
end
