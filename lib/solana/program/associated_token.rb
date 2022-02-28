module Solana
  module Program
    class AssociatedToken < Base
      PROGRAM_ID = 'ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL'
      MAX_SEED_LENGTH = 32
      LAMPORTS_FOR_TOKEN = 2039280

      class << self
        def create_associated_token_account_instruction(payer_pubkey:, associated_account_pubkey:, owner_pubkey:, token_pubkey:)
          keys = [
            { pubkey: payer_pubkey, is_signer: true, is_writable: true },
            { pubkey: associated_account_pubkey, is_signer: false, is_writable: true },
            { pubkey: owner_pubkey, is_signer: false, is_writable: false },
            { pubkey: token_pubkey, is_signer: false, is_writable: false },
            { pubkey: System::PROGRAM_ID , is_signer: false, is_writable: false },
            { pubkey: Token::PROGRAM_ID, is_signer: false, is_writable: false },
            { pubkey: System::SYSVAR_RENT_ID, is_signer: false, is_writable: false }
          ]
          represent(keys, [0])
        end

        def generate_associated_token_account(token_pubkey, owner_pubkey, nonce = 255)
          get_associated_token_address_for_program(PROGRAM_ID, Token::PROGRAM_ID, token_pubkey, owner_pubkey, nonce)
        end

        def get_associated_token_address_for_program(associatedprogram_pubkey, program_pubkey, token_pubkey, owner_pubkey, nonce = 255)
          seeds = [owner_pubkey, program_pubkey, token_pubkey].map{|s| Utils::base58_to_bytes(s)}
          seeds_with_nonce = seeds + [[nonce]]
          create_program_address(seeds_with_nonce, Utils::base58_to_bytes(associatedprogram_pubkey))
        end

        def create_program_address(seeds, program_id)
          seeds.each do |seed|
            raise (`Max seed length exceeded`) if seed.length > MAX_SEED_LENGTH
          end
          hash = (seeds + program_id + 'ProgramDerivedAddress'.unpack('C*')).flatten
          hash = Utils.sha256(hash.pack('C*'))[2..-1]
          bytes = [hash].pack('H*').bytes
          Utils.bytes_to_base58(bytes)
        end
      end
    end
  end
end