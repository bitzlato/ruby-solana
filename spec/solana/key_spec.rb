RSpec.describe Solana::Tx do
  let(:private_key) { [44, 98, 215, 237, 34, 123, 89, 247, 206, 196, 165, 5, 232, 42, 79, 158, 27, 20, 165, 137, 124, 155, 216, 126, 167, 178, 46, 57, 164, 181, 156, 43].pack('C*') }
  let(:address) { 'E7nuq9LaqPdL2SAMMZ4Tp7GGqbEXVXWHZyFdVxeaDz3N' }

  describe 'initialize' do
    it "generates new key" do
      expect(Solana::Key.new).not_to be nil
    end

    it "restores key from secret key" do
      key = Solana::Key.new(private_key)
      expect(key.private_key).to eq private_key
    end
  end

  describe "public_address" do
    it "returns valid address" do
      key = Solana::Key.new(private_key)
      expect(key.address).to eq address
    end
  end
end
