RSpec.describe Foobara::Util do
  before do
    stub_class "Foo" do
      def a
        # :nocov:
        "foo a"
        # :nocov:
      end
    end
    stub_class "Foo::Bar", Foo do
      def a
        # :nocov:
        "bar a"
        # :nocov:
      end
    end
    stub_class "Foo::Bar::Baz", Foo::Bar do
      def a
        # :nocov:
        "baz a"
        # :nocov:
      end
    end
  end

  describe ".descendants" do
    it "returns the descendants" do
      expect(described_class.descendants(Foo)).to contain_exactly(Foo::Bar, Foo::Bar::Baz)
    end
  end

  describe ".instances" do
    let(:klass) { stub_class "SomeClass" }

    it "returns the instances" do
      expect(described_class.instances(klass)).to be_empty

      instance = klass.new
      instance2 = klass.new

      expect(described_class.instances(klass)).to contain_exactly(instance, instance2)
    end
  end

  describe ".super_method_takes_parameters?" do
    it "returns if the super method takes parameters or not" do
      instance = Foo::Bar::Baz.new
      from_class = Foo::Bar

      expect(described_class.super_method_takes_parameters?(instance, from_class, :a)).to be(false)
    end
  end
end
