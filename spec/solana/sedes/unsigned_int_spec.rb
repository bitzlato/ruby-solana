RSpec.describe Solana::Sedes::UnsignedInt do
  # let(:size) { 4 }
  let(:number) { 2 }
  let(:string) { "\x02\x00\x00\x00" }

  it "serializes in unsigned 32" do
    int = Solana::Sedes.uint32
    result = int.serialize(2)
    expect(result).to eq(string)
  end

  it "deserializes to unsigned 32" do
    int = Solana::Sedes.uint32
    result = int.deserialize(string)
    expect(result).to eq(number)
  end
end
