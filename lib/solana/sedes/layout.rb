module Solana
  module Sedes
    class Layout
      attr_reader :fields

      def initialize(fields)
        @fields = fields
      end

      def serialize(params)
        fields.map do |field, type|
          sede = if type.is_a?(Symbol)
                   Solana::Sedes.send(type)
                 else
                   type
                 end

          sede.serialize(params[field])
        end.flatten
      end

      def deserialize(bytes)
        result = {}
        fields.map do |field, type|
          sede = if type.is_a?(Symbol)
                   Solana::Sedes.send(type)
                 else
                   type
                 end
          result[field] = sede.deserialize(bytes.shift(sede.size))
        end
        result
      end
    end
  end
end