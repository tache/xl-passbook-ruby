module Passbook
  module PassConfig
    class Validator
      REQUIRED = %i(cert_path cert_password template_path).freeze
      attr_reader :error

      def initialize(config_attrs)
        @config_attrs = config_attrs
        @error = ''
      end

      def valid?
        REQUIRED.all? { |attr| present? attr }
      end

      private

      def present?(attr)
        if config_attrs[attr].present? # no empty string!
          true
        else
          @error = "#{attr} is required in your config"
          false
        end
      end
    end
  end
end
