require 'spec_helper'

module Passbook
  module Validators
    describe PassConfig, '#valid?' do
      it 'requires cert_path' do
        attrs = { foo: 'bar' }
        validator = described_class.new attrs

        expect(validator).not_to be_valid
        expect(validator.error).to eq('cert_path is required in your config')
      end

      it 'requires cert_password' do
        attrs = { cert_path: 'bar' }
        validator = described_class.new attrs

        expect(validator).not_to be_valid
        expect(validator.error).to eq('cert_password is required in your config')
      end

      it 'requires template_path' do
        attrs = { cert_path: 'bar', cert_password: 'foo' }
        validator = described_class.new attrs

        expect(validator).not_to be_valid
        expect(validator.error).to eq('template_path is required in your config')
      end

      it 'is valid when required fields are defined' do
        attrs = { cert_path: 'bar', cert_password: 'foo', template_path: 'ha' }
        expect(described_class.new attrs).to be_valid
      end
    end
  end
end
