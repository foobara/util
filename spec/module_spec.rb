RSpec.describe Foobara::Util do
  # Why doesn't this work without the before?
  # TODO: fix this
  before do
    stub_module "Foo"
    stub_module "Foo::Bar"
    stub_module "Foo::Bar::Baz"
  end

  describe ".non_full_name" do
    subject { described_class.non_full_name(mod) }

    context "when passing a string" do
      let(:mod) { "Foo::Bar::Baz" }

      it { is_expected.to eq("Baz") }
    end

    context "when anonymous" do
      it "returns nil" do
        expect(described_class.non_full_name(Class.new)).to be_nil
      end
    end

    describe ".const_get_up_hierarchy" do
      subject { described_class.const_get_up_hierarchy(mod, name) }

      context "when anonymous class" do
        let(:mod) { Class.new(String) }
        let(:name) { :Hash }

        it { is_expected.to be(Hash) }

        context "when bad constant" do
          let(:name) { :NoSuchConstant }

          it { is_expected_to_raise(NameError, "uninitialized constant NoSuchConstant") }
        end
      end

      context "when nested modules" do
        let(:mod) { Foo::Bar::Baz }
        let(:name) { :Bar }

        it { is_expected.to be(Foo::Bar) }
      end
    end

    describe ".module_for" do
      it "returns the containing module" do
        expect(described_class.module_for(Foo::Bar::Baz)).to eq(Foo::Bar)
      end

      context "when module is anonymous" do
        it "returns nil" do
          expect(described_class.module_for(Class.new)).to be_nil
        end
      end

      context "when it has no parent" do
        it "returns nil" do
          expect(described_class.module_for(Foo)).to be_nil
        end
      end
    end

    describe ".non_full_name_underscore" do
      it "returns the non full name underscored" do
        expect(described_class.non_full_name_underscore(Foo::Bar::Baz)).to eq("baz")
      end
    end

    describe ".constant_value" do
      it "returns the constant value" do
        expect(described_class.constant_value(Foo::Bar, :Baz)).to eq(Foo::Bar::Baz)
      end
    end

    describe ".constant_values" do
      it "returns the constant values" do
        expect(described_class.constant_values(Foo)).to eq([Foo::Bar])
      end

      context "when constants are defined out of lexical order" do
        before do
          stub_module "Foo::BConst"
          stub_module "Foo::AConst"
        end

        it "returns the constants sorted in a deterministic order" do
          expect(described_class.constant_values(Foo)).to eq([Foo::AConst, Foo::BConst, Foo::Bar])
        end
      end

      context "with classes" do
        before do
          stub_class "Foo::Class1" do
            const_set(:CONST1, "const1")
          end
          stub_class "Foo::Class2", Foo::Class1 do
            const_set(:CONST2, "const2")
          end
        end

        context "when inherit is true" do
          it "returns the inherited constants" do
            expect(described_class.constant_values(Foo::Class2, inherit: true)).to contain_exactly("const1", "const2")
          end
        end

        context "when filtering by extends" do
          it "returns the expected values" do
            expect(described_class.constant_values(
                     Foo,
                     extends: Foo::Class1
                   )).to contain_exactly(Foo::Class1, Foo::Class2)
          end
        end
      end
    end
  end
end
