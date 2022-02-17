RSpec.describe Solana::Sedes::UnsignedInt do
  let(:small_number) { 2 }
  let(:number) { 2222 }
  let(:bytes8) {  [2] }
  let(:bytes32) { [174, 8, 0, 0] }
  let(:bytes64) { [174, 8, 0, 0, 0, 0, 0, 0] }

  it "serializes in unsigned 8" do
    int = Solana::Sedes.uint8
    result = int.serialize(small_number)
    expect(result).to eq(bytes8)
  end

  it "deserializes to unsigned 8" do
    int = Solana::Sedes.uint8
    result = int.deserialize(bytes8)
    expect(result).to eq(small_number)
  end

  it "serializes in unsigned 32" do
    int = Solana::Sedes.uint32
    result = int.serialize(number)
    expect(result).to eq(bytes32)
  end

  it "deserializes to unsigned 32" do
    int = Solana::Sedes.uint32
    result = int.deserialize(bytes32)
    expect(result).to eq(number)
  end

  it "serializes in unsigned 64" do
    int = Solana::Sedes.uint64
    result = int.serialize(number)
    expect(result).to eq(bytes64)
  end

  it "deserializes to unsigned 64" do
    int = Solana::Sedes.uint64
    result = int.deserialize(bytes64)
    expect(result).to eq(number)
  end


end
