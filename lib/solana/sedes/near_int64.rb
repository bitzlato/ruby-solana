module Solana
  module Sedes
    class NearInt64
      V2E32 = 2.pow(32)

      def initialize
        @size = 8
      end

      def serialize(obj)
        uint = UnsignedInt.new(32)
        numbers = divmod_int64(obj)
        numbers.map{|x| uint.serialize(x)}.join
        # if @size && obj >= 256**@size
        #   raise "Integer too large (does not fit in #{@size} bytes)"
        # end
      end

      def deserialize(serial)
        # raise "Invalid serialization (wrong size)" if @size && serial.size != @size
        # raise  "Invalid serialization (not minimal length)" if !@size && serial.size > 0

        uint = UnsignedInt.new(32)

        half_size = @size/2

        lo, hi = [serial[0..half_size-1], serial[half_size..-1]].map{|x| uint.deserialize(x)}

        rounded_int64(hi, lo)
      end

      def divmod_int64(obj)
        obj = obj * 1.0
        hi32 = (obj / V2E32).floor
        lo32 = (obj - (hi32 * V2E32)).floor
        [lo32, hi32]
      end

      def rounded_int64(hi32, lo32)
        hi32 * V2E32 + lo32
      end
    end
  end
end