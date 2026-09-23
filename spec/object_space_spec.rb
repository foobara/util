require "foobara/util/object_space"

RSpec.describe Foobara::Util do
  def without_deprecation_warnings(mod, method_name)
    original_method = mod.instance_method(method_name)

    allow_any_instance_of(mod).to receive(method_name) do |target, *args, **opts|
      old_deprecated_flag = Warning[:deprecated]

      begin
        Warning[:deprecated] = false
        if target.name == "RSpec::Core::Formatters"
          # let's just simulate loading constants here to avoid a warning when loading :BisectDRbFormatter
          next 1
        end

        original_method.bind_call(target, *args, **opts)
      ensure
        Warning[:deprecated] = old_deprecated_flag
      end
    end
  end

  before do
    without_deprecation_warnings(described_class.singleton_class, :object_id_to_object)
    without_deprecation_warnings(Module, :const_get)
  end

  describe "#referencing_paths" do
    it "returns paths of references that lead to the object" do
      object = Object.new

      another_object = Object.new.tap do |o|
        o.instance_variable_set(:@object, object)
      end

      an_array = [Object.new, another_object]
      a_hash = { foo: an_array }

      m = stub_module "SomeModule"
      m::SOME_CONSTANT = a_hash

      anon_module = Module.new
      anon_module::ANON_CONSTANT = SomeModule

      expect(anon_module::ANON_CONSTANT::SOME_CONSTANT[:foo][1].instance_variable_get(:@object)).to eq(object)

      referencing_paths = described_class.referencing_paths(object)

      expect(referencing_paths).to include([
                                             "AnonModule:#{anon_module.__id__}::ANON_CONSTANT",
                                             "SomeModule::SOME_CONSTANT",
                                             "<Hash:#{a_hash.__id__}>[:foo]",
                                             "<Array:#{an_array.__id__}>[1]",
                                             "<Object:#{another_object.__id__}>@object"
                                           ])
    end
  end

  describe "#object_id_to_object" do
    context "when recycled" do
      # perhaps not the greatest interface?
      it "returns nil" do
        o = Object.new
        object_id = o.__id__

        expect(described_class.object_id_to_object(object_id).__id__).to eq(o.__id__)

        # rubocop:disable-next Lint/UselessAssignment
        o = nil
        GC.start

        expect(described_class.object_id_to_object(object_id)).to be_nil
      end
    end
  end
end
