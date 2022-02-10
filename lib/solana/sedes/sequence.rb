module Solana
  module Sedes
    class Sequence
      def initialize count, type
        @count = count
        @type = type
      end

      def serialize items
        items.map do |item|
          @type.serialize(item)
        end.join
      end
    end
  end
end