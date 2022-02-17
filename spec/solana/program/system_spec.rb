RSpec.describe Solana::Program::System do
  let(:from) { 'E7nuq9LaqPdL2SAMMZ4Tp7GGqbEXVXWHZyFdVxeaDz3N' }
  let(:to) { '3wh7S43AJW5FyYnJUFbhn7hBvSSfuQbPozmf1xMohWiX' }
  let(:lamports) { 3000 }
  let(:result) {{
    data: [2, 0, 0, 0, 184, 11, 0, 0, 0, 0, 0, 0],
    keys: [
      {is_signer: true, is_writable: true, pubkey: "E7nuq9LaqPdL2SAMMZ4Tp7GGqbEXVXWHZyFdVxeaDz3N"},
      {is_signer: false, is_writable: true, pubkey: "3wh7S43AJW5FyYnJUFbhn7hBvSSfuQbPozmf1xMohWiX"}
    ],
    program_id: "11111111111111111111111111111111"
  }}

  it "generates valid signature" do
    res = Solana::Program::System.transfer_instruction(from_pubkey: from, to_pubkey: to, lamports: 3000)
    expect(res).to eq(result)
  end
end