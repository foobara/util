RSpec.describe Foobara::Util do
  before do
    stub_class "SomeClass"
  end

  let(:structured_object) do
    [
      { a: [{ b: 2 }, 15] },
      "foo",
      SomeClass
    ]
  end

  describe ".deep_stringify_keys" do
    it "stringifies keys throughout the structure" do
      expect(described_class.deep_stringify_keys(structured_object)).to eq(
        [
          {
            "a" => [
              { "b" => 2 },
              15
            ]
          },
          "foo",
          SomeClass
        ]
      )
    end
  end

  describe ".deep_symbolize_keys" do
    let(:structured_object) do
      [
        {
          "a" => [
            { "b" => 2 },
            15
          ]
        },
        "foo",
        SomeClass
      ]
    end

    it "symbolizes keys throughout the structure" do
      expect(described_class.deep_symbolize_keys(structured_object)).to eq(
        [
          {
            a: [
              { b: 2 },
              15
            ]
          },
          "foo",
          SomeClass
        ]
      )
    end
  end

  describe ".deep_dup" do
    it "duplicates the structure" do
      expect(described_class.deep_dup(structured_object)).to eq(structured_object)
    end
  end
end
