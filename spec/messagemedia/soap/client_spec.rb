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
                             },
                             {
                                 :key_converter => :none
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

  describe '#send_messages' do
    it 'sends multiple message' do
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
                          :'api:content' => 'Test 1',
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
                      },
                      {
                          :'api:content' => 'Test 2',
                          :'api:recipients' => {
                              :'api:recipient' => ['0491570157'],
                              :attributes! => {
                                  :'api:recipient' => {
                                      :uid => [1]
                                  }
                              }
                          },
                          :@format => 'SMS',
                          :@sequenceNumber => 0,
                          :'api:deliveryReport' => false,
                          :'api:validityPeriod' => 2,
                          :'api:origin' => '0491570109'
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
                                                 :@sent => '2',
                                                 :@scheduled => '0',
                                                 :@failed => '0'
                                             }
                                         }
                                     }
                                 }
                             },
                             {
                                 :key_converter => :none
                             })
      }

      savon.expects(:send_messages).with(message: expected_request_body).returns(packaged_response)

      client = described_class.new('username', 'password')

      message_1 = Messagemedia::SOAP::Message.new
      message_1.content = 'Test 1'
      message_1.add_recipient(0, '0491570156')
      message_1.origin = '0491570110'

      message_2 = Messagemedia::SOAP::Message.new
      message_2.content = 'Test 2'
      message_2.add_recipient(1, '0491570157')
      message_2.delivery_report = false
      message_2.validity_period = 2
      message_2.origin = '0491570109'

      result = client.send_messages([message_1, message_2])

      expect(result).to_not be_nil
      expect(result[:account_details]).to_not be_nil
      expect(result[:account_details][:@type]).to eq('daily')
      expect(result[:account_details][:@credit_limit]).to eq('500')
      expect(result[:account_details][:@credit_remaining]).to eq('497')
      expect(result[:@sent]).to eq('2')
      expect(result[:@scheduled]).to eq('0')
      expect(result[:@failed]).to eq('0')

    end
  end

  describe '#get_user_info' do
    it 'returns user info' do

      expected_request_body = {
          :'api:authentication' => {
              :'api:userId' => 'username',
              :'api:password' => 'password'
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
                                         :check_user_response => {
                                             :@xmlns => 'http://xml.m4u.com.au/2009',
                                             :result => {
                                                 :account_details => {
                                                     :@type => 'daily',
                                                     :@credit_limit => '500',
                                                     :@credit_remaining => '497'
                                                 },
                                                 :@sent => '2',
                                                 :@scheduled => '0',
                                                 :@failed => '0'
                                             }
                                         }
                                     }
                                 }
                             },
                             {
                                 :key_converter => :none
                             })
      }

      savon.expects(:check_user).with(message: expected_request_body).returns(packaged_response)

      client = described_class.new('username', 'password')

      result = client.get_user_info

      expect(result).to_not be_nil
      expect(result[:account_details]).to_not be_nil
      expect(result[:account_details][:@type]).to eq('daily')
      expect(result[:account_details][:@credit_limit]).to eq('500')
      expect(result[:account_details][:@credit_remaining]).to eq('497')

    end
  end

  describe '#block_numbers' do

    it 'blocks numbers' do

      numbers = %w(0491570156 0491392211)

      expected_request_body = {
          :'api:authentication' => {
              :'api:userId' => 'username',
              :'api:password' => 'password',
              :'api:recipients' => {
                  :'api:recipient' => numbers.each { |n| n }
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
                                         :block_numbers_response => {
                                             :@xmlns => 'http://xml.m4u.com.au/2009',
                                             :result => {
                                                 :@blocked => '2',
                                                 :@failed => '0'
                                             }
                                         }
                                     }
                                 }
                             },
                             {
                                 :key_converter => :none
                             })
      }

      savon.expects(:block_numbers).with(message: expected_request_body).returns(packaged_response)

      client = described_class.new('username', 'password')

      result = client.block_numbers(numbers)

      expect(result).to_not be_nil
      expect(result[:blocked]).to eq('2')
      expect(result[:failed]).to eq('0')
    end

  end

  describe '#unblock_numbers' do

    it 'unblocks numbers' do

      numbers = %w(0491570156 0491392211)

      expected_request_body = {
          :'api:authentication' => {
              :'api:userId' => 'username',
              :'api:password' => 'password',
              :'api:recipients' => {
                  :'api:recipient' => numbers.each { |n| n }
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
                                         :unblock_numbers_response => {
                                             :@xmlns => 'http://xml.m4u.com.au/2009',
                                             :result => {
                                                 :@unblocked => '2',
                                                 :@failed => '0'
                                             }
                                         }
                                     }
                                 }
                             },
                             {
                                 :key_converter => :none
                             })
      }

      savon.expects(:unblock_numbers).with(message: expected_request_body).returns(packaged_response)

      client = described_class.new('username', 'password')

      result = client.unblock_numbers(numbers)

      expect(result).to_not be_nil
      expect(result[:unblocked]).to eq('2')
      expect(result[:failed]).to eq('0')
    end

  end

  describe '#delete_scheduled_messages' do

    it 'deletes scheduled messages' do

      messageIds = %w(1234 89)

      expected_request_body = {
          :'api:authentication' => {
              :'api:userId' => 'username',
              :'api:password' => 'password',
              :'api:messages' => {
                  :'api:message' => messageIds.each { |n| n }
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
                                         :delete_scheduled_messages_response => {
                                             :@xmlns => 'http://xml.m4u.com.au/2009',
                                             :result => {
                                                 :@unscheduled => '2',
                                                 :@failed => '0'
                                             }
                                         }
                                     }
                                 }
                             },
                             {
                                 :key_converter => :none
                             })
      }

      savon.expects(:delete_scheduled_messages).with(message: expected_request_body).returns(packaged_response)

      client = described_class.new('username', 'password')

      result = client.delete_scheduled_messages(messageIds)

      expect(result).to_not be_nil
      expect(result[:unscheduled]).to eq('2')
      expect(result[:failed]).to eq('0')
    end

  end


end