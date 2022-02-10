module Solana
  module Sedes
    class Layout
      attr_reader :fields

      def initialize(fields)
        @fields = fields
      end

      def serialize(params)
        fields.map do |field, type|

          klass = if type.is_a?(Symbol)
                    Solana::Sedes.send(type)
                  else
                    type
                  end

          klass.serialize(params[field])
        end.join
      end
    end
  end
end