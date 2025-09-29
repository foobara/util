RSpec.describe Foobara::Util do
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
                                             "AnonModule:#{anon_module.object_id}::ANON_CONSTANT",
                                             "SomeModule::SOME_CONSTANT",
                                             "<Hash:#{a_hash.object_id}>[:foo]",
                                             "<Array:#{an_array.object_id}>[1]",
                                             "<Object:#{another_object.object_id}>@object"
                                           ])
    end
  end

  describe "#object_id_to_object" do
    context "when recycled" do
      # perhaps not the greatest interface?
      it "returns nil" do
        o = Object.new
        object_id = o.object_id

        expect(described_class.object_id_to_object(object_id).object_id).to eq(o.object_id)

        # rubocop:disable Lint/UselessAssignment
        o = nil
        # rubocop:enable Lint/UselessAssignment
        GC.start

        expect(described_class.object_id_to_object(object_id)).to be_nil
      end
    end
  end
end
