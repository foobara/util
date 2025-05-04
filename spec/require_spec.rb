RSpec.describe Foobara::Util do
  describe ".require_directory" do
    it "requires the directory" do
      expect { described_class.require_directory("#{__dir__}/../lib/") }.to_not raise_error
    end
  end
end
