require 'test/unit'

require_relative '../lib/messagemedia/soap/recipient'

class TestRecipient < Test::Unit::TestCase

    def test_to_api_hash

        # First test receipient, with a custom message ID
        recipient = Messagemedia::SOAP::Recipient.new(123, 123456)
        assert_equal({
            :'api:recipient' => 123456,
            :'attributes!' => {
                :'api:recipient' => { 'uid' => 123 }
            }
        }, recipient.to_api_hash)

        # Second test recipient, no message ID
        recipient = Messagemedia::SOAP::Recipient.new(nil, 123456)
        assert_equal({
            :'api:recipient' => 123456
        }, recipient.to_api_hash)

    end

end