require 'test_helper'

class TestMessage < Test::Unit::TestCase

  def test_to_api_hash
    message = Messagemedia::SOAP::Message.new

    # First test recipient, with a custom message ID
    message_id_1 = 100
    recipient_1 = 123456
    message.add_recipient(message_id_1, recipient_1)

    # Second test recipient, no message ID
    recipient_2 = 456789
    message.add_recipient(nil, recipient_2)

    expected_hash = {
        :'@format' => message.format,
        :'@sequenceNumber' => message.sequence_number,
        :'api:deliveryReport' => message.delivery_report,
        :'api:validityPeriod' => message.validity_period,
        :'api:content' => message.content,
        :'api:recipients' => {
            :'api:recipient' => [
                recipient_1,
                recipient_2
            ],
            :attributes! => {
                :'api:recipient' => {
                    :uid => [
                        message_id_1,
                        nil
                    ]
                }
            }
        }
    }

    assert_equal(expected_hash, message.to_api_hash)

  end

end