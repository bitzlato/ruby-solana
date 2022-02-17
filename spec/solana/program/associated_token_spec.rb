RSpec.describe Solana::Program::AssociatedToken do
  context "token account instruction transfer" do
    let(:params) {
      {
        token_pubkey: '3uLZa2QxzimsSAtFhkwFyCWK3qTPRrdkf2fRoVKxaUtR',
        associated_account_pubkey: '2jdRraoFo3aAHMXiGZrgyF1XKnYQzcPeNz7sUstdXgfs',
        owner_pubkey: '78j7jDXPJwTBxazaSYWnqftzrZt8YTKiLKnvgSB4Ekox',
        payer_pubkey: 'HizyfeSmxUSvER7NJuY4yA9YpG2qwUFEvk6Eby7CzTMP',
      }
    }
    let(:result) {{
      :data=>[0],
      :keys=> [
        {:is_signer=>true, :is_writable=>true, :pubkey=>"HizyfeSmxUSvER7NJuY4yA9YpG2qwUFEvk6Eby7CzTMP"},
        {:is_signer=>false, :is_writable=>true, :pubkey=>"2jdRraoFo3aAHMXiGZrgyF1XKnYQzcPeNz7sUstdXgfs"},
        {:is_signer=>false, :is_writable=>false, :pubkey=>"78j7jDXPJwTBxazaSYWnqftzrZt8YTKiLKnvgSB4Ekox"},
        {:is_signer=>false, :is_writable=>false, :pubkey=>"3uLZa2QxzimsSAtFhkwFyCWK3qTPRrdkf2fRoVKxaUtR"},
        {:is_signer=>false, :is_writable=>false, :pubkey=>"11111111111111111111111111111111"},
        {:is_signer=>false, :is_writable=>false, :pubkey=>"TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA"},
        {:is_signer=>false, :is_writable=>false, :pubkey=>"SysvarRent111111111111111111111111111111111"}
      ],
      :program_id => "ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL"
    }}

    it "generates valid instructions" do
      res = Solana::Program::AssociatedToken.create_associated_token_account_instruction(params)
      expect(res).to eq(result)
    end
  end

  context "generation of token account" do
    let(:token_pubkey) { '3uLZa2QxzimsSAtFhkwFyCWK3qTPRrdkf2fRoVKxaUtR' }
    let(:owner_pubkey) { '78j7jDXPJwTBxazaSYWnqftzrZt8YTKiLKnvgSB4Ekox' }
    let(:token_account_pubkey) { 'GEXRFCqrmhgvPefZb6PFzRojzHabFjVjZbvdx1Xm3DAr' }

    it "generates valid signature" do
      result = Solana::Program::AssociatedToken.generate_associated_token_account(token_pubkey, owner_pubkey)
      expect(result).to eq(token_account_pubkey)
    end
  end

  context "generation of token account" do
    let(:token_pubkey) { '98CDfRHgyLRjBgSbE11FwxoUQDXHJVMj2YY13j2ujMgx' }
    let(:owner_pubkey) { '7q2TMXKKh63uw738xvnFsMQGKLD11hVuP6fqFuuv1E5T' }
    let(:token_account_pubkey) { 'H2qJEyqxDWEWjpudgbXk2W1TVXb8GQXbYpVGN4CFcDyH' }

    it "generates valid signature" do
      result = Solana::Program::AssociatedToken.generate_associated_token_account(token_pubkey, owner_pubkey)
      expect(result).to eq(token_account_pubkey)
    end
  end
end