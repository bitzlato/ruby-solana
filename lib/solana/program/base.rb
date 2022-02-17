module Solana
  module Program
    class Base
      class << self
        def encode_data(fields, data)
          layout = Solana::Sedes::Layout.new(fields)
          layout.serialize(data)
        end

        def decode_data(fields, data)
          layout = Solana::Sedes::Layout.new(fields)
          layout.deserialize(data)
        end

        def represent keys, data
          {
            keys: keys,
            program_id: self::PROGRAM_ID,
            data: data
          }
        end
      end
    end
  end
end
