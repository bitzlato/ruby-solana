require 'base58'

module Solana
  class Utils
    class << self
      def decode_length(bytes)
        len = 0
        size = 0
        while true do
          elem = bytes.shift
          len |= (elem & 0x7f) << (size * 7)
          size += 1
          break if ((elem & 0x80) === 0)
        end
        len
      end

      def encode_length(len)
        bytes = []
        rem_len = len
        while true do
          elem = rem_len & 0x7f
          rem_len >>= 7
          if rem_len == 0
            bytes.push(elem)
            break
          else
            elem |= 0x80
            bytes.push(elem)
          end
        end
        bytes
      end

      def bytes_to_base58(bytes)
        Base58.binary_to_base58(bytes.pack('C*'), :bitcoin)
      end

      def base58_to_bytes(string)
        Base58.base58_to_binary(string, :bitcoin).bytes
      end
    end
  end
end
