require "ed25519"

module Solana
  class Key
    def initialize(private_key=nil)
      @ed_key = if private_key
                  Ed25519::SigningKey.new(private_key)
                else
                  Ed25519::SigningKey.generate
                end
    end

    def private_key
      @ed_key.to_bytes
    end

    def public_key
      @ed_key.verify_key.to_bytes
    end

    def address
      @address ||= Base58.binary_to_base58(public_key, :bitcoin)
    end

    def sign(message)
      @ed_key.sign(message)
    end

    def private_hex
      private_key.unpack('H*').first
    end
  end
end
