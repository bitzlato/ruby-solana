module Solana
  module Program
    class Base
      class << self
        def encode_data(type, params)
          params = params.merge({instruction: type[:index]})
          layout = Solana::Sedes::Layout.new(type[:layout])
          layout.serialize(params).bytes
        end
      end
    end
  end
end
