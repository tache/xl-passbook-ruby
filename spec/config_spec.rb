
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

require 'spec_helper'

module Passbook
  describe Config do
    # it "should throw ArgumentError because wwdr_intermediate_certificate_path is missing"  do
    #   expect {Passbook::Config.instance.configure {}}.to raise_error(ArgumentError)
    # end

    it 'should throw ArgumentError because cert_path is missing' do
      expect {
        Passbook::Config.instance.add_pkpass do |passbook|
          passbook.wwdr_intermediate_certificate_path = 'test'
          passbook.wwdr_certificate = OpenSSL::X509::Certificate.new
          passbook.pass_config['pass.com.acme'] = {
            'cert_password' => 'foo',
            'template_path' =>'tmp'
          }
        end
      }.to raise_error(ArgumentError, 'cert_path is required in your config')
    end

    it 'should throw ArgumentError because cert_password is missing' do
      expect {
        Passbook::Config.instance.add_pkpass do |passbook|
          passbook.wwdr_intermediate_certificate_path = 'test'
          passbook.wwdr_certificate = OpenSSL::X509::Certificate.new
          passbook.pass_config['pass.com.acme'] = {
            'cert_path' =>'tmp',
            'template_path' =>'tmp'
          }
        end
      }.to raise_error(ArgumentError, 'cert_password is required in your config')
    end

    it 'throws ArgumentError when template_password is missing' do
      expect {
        Passbook::Config.instance.add_pkpass do |passbook|
          passbook.wwdr_intermediate_certificate_path = 'test'
          passbook.wwdr_certificate = OpenSSL::X509::Certificate.new
          passbook.pass_config['pass.com.acme'] = {
            'cert_path' =>'tmp',
            'cert_password' => 'haha'
          }
        end
      }.to raise_error(ArgumentError, 'template_path is required in your config')
    end

    it 'throws no errors when required config settings are present' do
      expect {
        Passbook::Config.instance.add_pkpass do |passbook|
          passbook.wwdr_intermediate_certificate_path = 'test'
          passbook.wwdr_certificate = OpenSSL::X509::Certificate.new
          passbook.pass_config['pass.com.acme'] = {
            'cert_path' => 'tmp',
            'cert_password' => 'haha',
            'template_path' =>'tmp'
          }
        end
      }.not_to raise_error(ArgumentError)
    end
  end
end
