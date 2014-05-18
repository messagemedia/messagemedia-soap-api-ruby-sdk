require 'test/unit'

require_relative '../lib/messagemedia/message'

class TestMessage < Test::Unit::TestCase

    def test_to_api_hash

        message = Messagemedia::Message.new

        # First test receipient, with a custom message ID
        message_id_1 = 100
        recipient_1 = 123456
        message.add_recipient(message_id_1, recipient_1)

        # Second test recipient, no message ID
        recipient_2 = 456789
        message.add_recipient(nil, recipient_2)

        expected_hash = {
            :'@format' => message.format,
            :'@sequenceNumber' => message.sequence_number,
            :'api:origin' => message.origin,
            :'api:deliveryReport' => message.delivery_report,
            :'api:validityPeriod' => message.validity_period,
            :'api:content' => message.content,
            :'api:recipients' => [
                {
                    :'api:recipient' => recipient_1,
                    :'attributes!' => {
                        :'api:recipient' => {
                            'uid' => message_id_1
                        }
                    }
                },
                {
                    :'api:recipient' => recipient_2
                }
            ]
        }

        assert_equal(expected_hash, message.to_api_hash)

    end

end