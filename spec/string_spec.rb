RSpec.describe Foobara::Util do
  describe ".underscore" do
    context "when symbol" do
      it "still works" do
        expect(described_class.underscore(:ClassMethods)).to eq("class_methods")
      end
    end
  end

  describe ".underscore_sym" do
    it "underscores" do
      expect(described_class.underscore_sym(:"Foo_Bar!bazYo")).to eq(:"foo_bar!baz_yo")
    end
  end

  describe ".kebab_case" do
    it "kebab cases the thing" do
      expect(described_class.kebab_case(:foo_bar_baz)).to eq("foo-bar-baz")
      expect(described_class.kebab_case("FooBarBaz::FooBar")).to eq("foo-bar-baz::foo-bar")
    end
  end

  describe ".camelize" do
    it "camelizes" do
      expect(described_class.camelize(:class_methods)).to eq("classMethods")
    end
  end

  describe ".classify" do
    it "classifies" do
      expect(described_class.classify("class_methods")).to eq("ClassMethods")
    end

    context "when kebab instead of underscore" do
      it "classifies" do
        expect(described_class.classify("class-methods-kebab")).to eq("ClassMethodsKebab")
      end
    end
  end

  describe ".constantify_sym" do
    it "constantifies" do
      expect(described_class.constantify_sym("ClassMethods")).to eq(:CLASS_METHODS)
    end

    context "when already constantified" do
      it "returns the thing duped" do
        expect(described_class.constantify_sym(:CLASS_METHODS)).to eq(:CLASS_METHODS)
      end
    end
  end

  describe ".to_or_sentence" do
    it "joins the phrases with 'or'" do
      expect(described_class.to_or_sentence(%w[foo bar baz])).to eq("foo, bar, or baz")
    end

    context "with only one phrase" do
      it "returns the phrase" do
        expect(described_class.to_or_sentence(%w[foo])).to eq("foo")
      end
    end
  end

  describe ".humanize" do
    it "humanizes" do
      expect(described_class.humanize(:foo_bar_baz)).to eq("Foo bar baz")
    end
  end
end
