module Solana
  module Sedes
    class Blob
      attr_reader :size

      def initialize(size)
        @size = size
      end

      def serialize(obj)
        obj = [obj] unless obj.is_a?(Array)
        obj.pack('C*').bytes
      end

      def deserialize(bytes)
        bytes.pack('C*')
      end
    end
  end
end