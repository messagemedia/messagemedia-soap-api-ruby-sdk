require_relative '../../spec_helper'

require 'savon/mock/spec_helper'

describe Messagemedia::SOAP::Client do
  include Savon::SpecHelper

  before(:all) { savon.mock! }
  after(:all) { savon.unmock! }

  describe '#send_message' do
    it 'sends a message' do

      expected_request_body = {
          :'api:authentication' => {
              :'api:userId' => 'username',
              :'api:password' => 'password'
          },
          :'api:requestBody' => {
              :'api:messages' => {
                  :@sendMode => 'normal',
                  :'api:message' => [
                      {
                          :'api:content' => 'Test',
                          :'api:recipients' => {
                              :'api:recipient' => ['0491570156'],
                              :attributes! => {
                                  :'api:recipient' => {
                                      :uid => [0]
                                  }
                              }
                          },
                          :@format => 'SMS',
                          :@sequenceNumber => 0,
                          :'api:deliveryReport' => true,
                          :'api:validityPeriod' => 1,
                          :'api:origin' => '0491570110'
                      }
                  ]
              }
          }
      }

      packaged_response = {
          :code => 200,
          :headers => {},
          :body => Gyoku.xml({
              :'SOAP-ENV:Envelope' => {
                  :'@xmlns:SOAP-ENV' => 'http://schemas.xmlsoap.org/soap/envelope/',
                  :'@xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
                  :'@xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                  :'@xmlns:SOAP-ENC' => 'http://schemas.xmlsoap.org/soap/encoding/',
                  :'SOAP-ENV:Body' => {
                      :send_messages_response => {
                          :@xmlns => 'http://xml.m4u.com.au/2009',
                          :result => {
                              :account_details => {
                                  :@type => 'daily',
                                  :@credit_limit => '500',
                                  :@credit_remaining => '497'
                              },
                              :@sent => '1',
                              :@scheduled => '0',
                              :@failed => '0'
                          }
                      }
                  }
              }
          })
      }

      savon.expects(:send_messages).with(message: expected_request_body).returns(packaged_response)

      client = described_class.new('username', 'password')
      result = client.send_message('0491570156', 'Test', 0, '0491570110')

      expect(result).to_not be_nil
      expect(result[:account_details]).to_not be_nil
      expect(result[:account_details][:@type]).to eq('daily')
      expect(result[:account_details][:@credit_limit]).to eq('500')
      expect(result[:account_details][:@credit_remaining]).to eq('497')
      expect(result[:@sent]).to eq('1')
      expect(result[:@scheduled]).to eq('0')
      expect(result[:@failed]).to eq('0')

    end
  end
end