module Solana
  module Program
    class System < Base
      PROGRAM_ID = '11111111111111111111111111111111'
      SYSVAR_RENT_ID = 'SysvarRent111111111111111111111111111111111'

      INSTRUCTION_LAYOUTS = {
        # transfer
        2 => {
          instruction: :uint32,
          lamports: :near_int64
        }
      }

      class << self
        def transfer_instruction(from_pubkey:, to_pubkey:, lamports:)
          fields = INSTRUCTION_LAYOUTS[2]
          data = encode_data(fields, {instruction: 2, lamports: lamports})

          keys = [
            { pubkey: from_pubkey, is_signer: true, is_writable: true },
            { pubkey: to_pubkey, is_signer: false, is_writable: true }
          ]

          represent(keys, data)
        end
      end
    end
  end
end