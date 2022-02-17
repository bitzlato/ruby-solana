RSpec.describe Solana::Sedes::Layout do
  let(:fields) { {instruction: :uint32, lamports: :near_int64 } }
  let(:params) { {instruction: 2, lamports: 3000} }
  let(:bytes) { [2, 0, 0, 0, 184, 11, 0, 0, 0, 0, 0, 0] }

  it "serializes" do
    layout = Solana::Sedes::Layout.new(fields)
    result = layout.serialize(params)
    expect(result).to eq(bytes)
  end

  it "deserializes" do
    layout = Solana::Sedes::Layout.new(fields)
    result = layout.deserialize(bytes)
    expect(result).to eq(params)
  end
end
