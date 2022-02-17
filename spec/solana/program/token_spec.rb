RSpec.describe Solana::Program::Token do
  context "token trasnfer" do
    let(:params) {
      {
        from_pubkey: 'BEtBUxQDwWX8cLhVFhU4JFsGiHFjsv3XMzQ4b2KPrLjV',
        from_token_account_pubkey: '368aSxiAESiQ5B33x2AwqE3RP64HYS7Tv2VjEsVjS1Ns',
        to_token_account_pubkey: 'AaqCRXYKhebaRSC9k4Y1bb3Fniko6BJ4dQ4vDDAhk6N2',
        token_pubkey: 'HizyfeSmxUSvER7NJuY4yA9YpG2qwUFEvk6Eby7CzTMP',
        amount: 7000000000,
        decimals: 9
      }
    }
    let(:result) {{
      data: [12, 0, 134, 59, 161, 1, 0, 0, 0, 9],
      keys: [
        {:is_signer=>false, :is_writable=>true, :pubkey=>"368aSxiAESiQ5B33x2AwqE3RP64HYS7Tv2VjEsVjS1Ns"},
        {:is_signer=>false, :is_writable=>false, :pubkey=>"HizyfeSmxUSvER7NJuY4yA9YpG2qwUFEvk6Eby7CzTMP"},
        {:is_signer=>false, :is_writable=>true, :pubkey=>"AaqCRXYKhebaRSC9k4Y1bb3Fniko6BJ4dQ4vDDAhk6N2"},
        {:is_signer=>false, :is_writable=>false, :pubkey=>"BEtBUxQDwWX8cLhVFhU4JFsGiHFjsv3XMzQ4b2KPrLjV"}
      ],
      program_id: "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA"
    }}

    it "generates valid signature" do
      res = Solana::Program::Token.transfer_checked_instruction(params)
      expect(res).to eq(result)
    end
  end
end