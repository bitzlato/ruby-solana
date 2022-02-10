RSpec.describe Solana::Sedes::Layout do
  let(:fields) { {instruction: :uint32, lamports: :near_int64 } }
  let(:params) { {instruction: 2, lamports: 3000} }
  let(:result) { [2, 0, 0, 0, 184, 11, 0, 0, 0, 0, 0, 0] }

  it "serializes" do
    layout = Solana::Sedes::Layout.new(fields)
    bytes = layout.serialize(params).bytes
    expect(bytes).to eq(result)
  end
end
