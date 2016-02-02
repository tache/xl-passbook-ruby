
#  Copyright 2012 Xtreme Labs

#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

require 'fileutils'
require 'singleton'
require 'passbook/validators/pass_config'

module Passbook
  class Config
    include Singleton

    attr_accessor :pass_config,
                  :wwdr_intermediate_certificate_path,
                  :wwdr_certificate,
                  :preload_template,
                  :enable_routes

    def configure
      self.pass_config = Hash.new unless self.pass_config
      yield self
      read_wwdr_certificate
    end

    def add_pkpass
      self.pass_config = Hash.new unless self.pass_config
      yield self
      self.preload_template ||= ::Rails.env.production? if defined? ::Rails
      validate_config
      read_templates if self.preload_template
      read_p12_certificates
    end

    def validate_config
      self.pass_config.values.each do |config|
        validator = Passbook::Validators::PassConfig.new config
        error validator.error unless validator.valid?
      end
    end

    def read_templates
      self.pass_config.values.each do |config|
        config['files'] ||= load_files config['template_path']
      end
    end

    def load_files(path)
      files = {}

      Dir.glob(path+"/**/**").each do |file_path|
        next if File.directory? file_path
        filename = Pathname.new(file_path).relative_path_from(Pathname.new(path))
        file = File.open(file_path, "rb")
        files[filename.to_s] = File.read(file)
      end
      files
    end

    def read_p12_certificates
      pass_config.values.each do |config|
        config['p12_certificate'] ||= read_p12_certificate(config)
      end
    end

    def read_wwdr_certificate
      # raise(ArgumentError, "Please specify the WWDR Intermediate certificate in your initializer") unless self.wwdr_intermediate_certificate_path
      self.wwdr_certificate||= OpenSSL::X509::Certificate.new(File.read(self.wwdr_intermediate_certificate_path))
    end

    def error(message, kind = ArgumentError)
      raise kind, message
    end

    def read_p12_certificate(config)
      file = File.read config['cert_path']
      OpenSSL::PKCS12::new file, config['cert_password']
    rescue OpenSSL::PKCS12::PKCS12Error => error
      error "#{error.message} - Verify cert_password in your config is correct"
    end
  end
end

