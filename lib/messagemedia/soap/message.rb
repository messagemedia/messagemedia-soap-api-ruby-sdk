module Messagemedia
  module SOAP

    FORMAT_SMS = 'SMS'
    FORMAT_VOICE = 'voice'

    #
    # This class is a light-weight wrapper around the message structure used
    # by the MessageMedia SOAP Client interface.
    #
    class Message
      attr_accessor :sequence_number, :origin, :recipients, :content,
                    :validity_period, :format, :delivery_report, :scheduled

      #
      # Initialize an empty Message object
      #
      # By default, delivery reports will be enabled, the validity
      # period will be set to 10 minutes, and the message will be sent as
      # an SMS.
      #
      def initialize
        @recipients = []
        @delivery_report = true
        @validity_period = 1
        @sequence_number = 0
        @format = FORMAT_SMS
        @scheduled = nil
      end

      #
      # Add a recipient.
      #
      # An optional message ID (message_id) may be provided. This allows
      # for the correlation of replies and delivery reports with messages
      # that have been sent.
      #
      # A recipient number (recipient) must be provided.
      #
      def add_recipient(message_id, recipient)
        @recipients.push(Recipient.new(message_id, recipient))
      end

      #
      # Return a hash that can be passed to the Savon SOAP library to
      # represent a message.
      #
      def to_api_hash
        hash = {
            :'api:content' => @content,
            :'api:recipients' => {
                :'api:recipient' => @recipients.map { |r| r.destination_number },
                :attributes! => {
                    :'api:recipient' => {
                        :uid => @recipients.map { |r| r.message_id }
                    }
                }
            }
        }

        unless @format.nil?
          hash[:'@format'] = @format
        end
        unless @sequence_number.nil?
          hash[:'@sequenceNumber'] = @sequence_number
        end
        unless @delivery_report.nil?
          hash[:'api:deliveryReport'] = @delivery_report
        end
        unless @validity_period.nil?
          hash[:'api:validityPeriod'] = @validity_period
        end
        unless @origin.nil?
          hash[:'api:origin'] = @origin
        end
        unless @scheduled.nil?
          hash[:'api:scheduled'] = @scheduled
        end

        hash
      end
    end

  end
end
