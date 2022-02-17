RSpec.describe Solana::Sedes::Sequence do
  let(:num) { 3 }
  let(:sequence) { Solana::Sedes::Sequence.new(num, Solana::Sedes::UnsignedInt.new(32)) }
  let(:numbers) { [333, 888, 444] }
  let(:bytes) { [77, 1, 0, 0, 120, 3, 0, 0, 188, 1, 0, 0] }

  it "serializes" do
    result = sequence.serialize(numbers)
    expect(result).to eq(bytes)
  end

  it "deserializes" do
    result = sequence.deserialize(bytes)
    expect(result).to eq(numbers)
  end
end
