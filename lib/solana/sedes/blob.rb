module Solana
  module Sedes
    class Blob
      def initialize(size)
        @size = size
      end

      def serialize(obj)
        obj = [obj].compact unless obj.is_a?(Array)
        obj.pack('C*')
      end
    end
  end
end