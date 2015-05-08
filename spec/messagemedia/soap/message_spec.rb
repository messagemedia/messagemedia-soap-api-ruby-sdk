require_relative '../../spec_helper'

describe Messagemedia::SOAP::Message do
  let!(:message) { described_class.new }

  describe '#to_api_hash' do
    context 'multiple recipients' do
      let!(:message_id_1) { 100 }
      let!(:recipient_1) { 123456 }
      let!(:recipient_2) { 456789 }

      before do
        # First test recipient, with a custom message ID
        message.add_recipient(message_id_1, recipient_1)
        # Second test recipient, no message ID
        message.add_recipient(nil, recipient_2)
      end

      it 'should produce the correct hash' do
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
        expect(message.to_api_hash).to eq(expected_hash)
      end

    end
  end
end