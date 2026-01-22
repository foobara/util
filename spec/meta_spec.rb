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
        expect(klass.name).to eq("A")
      end

      context "when class name is a symbol" do
        it "creates the class with the expected superclass" do
          klass = described_class.make_class(:A, String)
          expect(klass.superclass).to be(String)
          expect(klass.name).to eq("A")
        end
      end

      context "when fully-qualified" do
        it "creates the class with the expected superclass" do
          klass = described_class.make_class("::A", String)
          expect(klass.superclass).to be(String)
          expect(klass.name).to eq("A")
        end
      end

      context "when it already exists" do
        it "returns the existing class" do
          # rubocop:disable Lint/ConstantDefinitionInBlock
          # rubocop:disable RSpec/LeakyConstantDeclaration
          class A
            def bar = "bar"
          end
          # rubocop:enable RSpec/LeakyConstantDeclaration
          # rubocop:enable Lint/ConstantDefinitionInBlock

          klass = described_class.make_class("A", String) do
            def baz = "baz"
          end
          expect(klass).to be(A)
          expect(klass.new.bar).to eq("bar")
        end
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

  describe ".make_class_p" do
    before do
      described_class.make_module("A")
    end

    it "creates all the missing modules along the way and tags non-existent ones" do
      described_class.make_class_p("A::B::C::D", String, tag: true)

      expect(A::B).to be_a(Module)
      expect(A::B::C).to be_a(Module)
      expect(A::B::C::D).to be_a(Class)
      expect(A::B::C::D).to be < String

      expect(A.instance_variable_defined?(:@foobara_created_via_make_class)).to be(false)
      expect(A::B.instance_variable_defined?(:@foobara_created_via_make_class)).to be(true)
      expect(A::B::C.instance_variable_defined?(:@foobara_created_via_make_class)).to be(true)
      expect(A::B::C::D.instance_variable_defined?(:@foobara_created_via_make_class)).to be(true)
    end
  end

  describe ".make_module_p" do
    before do
      described_class.make_module("A")
    end

    it "creates all the missing modules along the way" do
      described_class.make_module_p("A::B::C::D")

      expect(A::B).to be_a(Module)
      expect(A::B::C).to be_a(Module)
      expect(A::B::C::D).to be_a(Module)
    end
  end
end
