module Solana
  module Program
    class Token < Base
      PROGRAM_ID = 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA'

      INSTRUCTION_LAYOUTS = {
        transfer_checked: {
          index: 12,
          layout: {
            instruction: :uint8,
            amount: :uint64,
            decimals: :uint8
          }
        },
      }

      class << self
        def transfer_checked(from_pubkey:, from_token_account_pubkey:, to_token_account_pubkey:, token_pubkey:, amount:, decimals:)
          type = INSTRUCTION_LAYOUTS[:transfer_checked]
          data = encode_data(type, {amount: amount, decimals: decimals})

          keys = [
            {pubkey: from_token_account_pubkey, is_signer: false, is_writable: true},
            {pubkey: token_pubkey, is_signer: false, is_writable: false},
            {pubkey: to_token_account_pubkey, is_signer: false, is_writable: true},
            {pubkey: from_pubkey, is_signer: false, is_writable: false}
          ]
          {
            keys: keys,
            program_id: PROGRAM_ID,
            data: data
          }
        end
      end
    end
  end
end