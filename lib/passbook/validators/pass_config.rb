module Passbook
  module Validators
    class PassConfig
      REQUIRED = %w(cert_path cert_password template_path).freeze
      attr_reader :error

      def initialize(config_attrs)
        @config_attrs = config_attrs
        @error = ''
      end

      def valid?
        REQUIRED.all? { |attr| present? attr }
      end

      private

      attr_reader :config_attrs

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
