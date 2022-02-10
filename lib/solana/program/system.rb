module Solana
  module Program
    class System < Base
      PROGRAM_ID = '11111111111111111111111111111111'

      INSTRUCTION_LAYOUTS = {
        transfer: {
          index: 2,
          layout: {
            instruction: :uint32,
            lamports: :near_int64
          }
        },
      }

      class << self
        def transfer(from_pubkey:, to_pubkey:, lamports:)
          type = INSTRUCTION_LAYOUTS[:transfer]
          data = encode_data(type, {lamports: lamports})

          keys = [
            { pubkey: from_pubkey, is_signer: true, is_writable: true },
            { pubkey: to_pubkey, is_signer: false, is_writable: true }
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