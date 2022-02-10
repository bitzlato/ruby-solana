RSpec.describe Solana::Sedes::NearInt64 do
  let(:number) { 3000 }
  let(:bytes) { [184, 11, 0, 0, 0, 0, 0, 0] }

  it "serializes" do
    near_int = Solana::Sedes::NearInt64.new
    result = near_int.serialize(3000)
    expect(result.bytes).to eq(bytes)
  end

  # it "deserializes" do
  #   near_int = Solana::Sedes::NearInt64.new
  #   result = near_int.deserialize(bytes.pack('C*'))
  #   expect(result).to eq(number)
  # end
end
