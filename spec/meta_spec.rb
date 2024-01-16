RSpec.describe Foobara::Util do
  after do
    if Object.const_defined?(:A)
      Object.send(:remove_const, :A)
    end
  end

  describe ".make_class" do
    context "when parent modules don't exist" do
      it "raises an error" do
        expect {
          described_class.make_class("A::B")
        }.to raise_error(described_class::ParentModuleDoesNotExistError)
      end
    end

    context "with superclass" do
      it "creates the class with the expected superclass" do
        klass = described_class.make_class("A", String)

        expect(klass.superclass).to be(String)
      end
    end

    context "with a block" do
      it "class-evals the block" do
        klass = described_class.make_class("A") do
          attr_accessor :a
        end

        expect(klass.new).to respond_to(:a)
      end
    end
  end

  describe ".make_module" do
    context "with a block" do
      it "module-evals the block" do
        mod = described_class.make_module("A") do
          module_function

          def a
            "a"
          end
        end

        expect(mod.a).to eq("a")
      end
    end
  end
end
