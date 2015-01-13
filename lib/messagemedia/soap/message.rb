module Messagemedia

    module SOAP

        FORMAT_SMS = "SMS"
        FORMAT_VOICE = "voice"

        #
        # This class is a light-weight wrapper around the message structure used
        # by the MessageMedia SOAP Client interface.
        #
        class Message

            attr_accessor :sequence_number, :origin, :recipients, :content,
                          :validity_period, :format, :delivery_report

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

                if not @format.nil? then
                  hash[:'@format'] = @format
                end

                if not @sequence_number.nil? then
                  hash[:'@sequenceNumber'] = @sequence_number
                end

                if not @delivery_report.nil? then
                  hash[:'api:deliveryReport'] = @delivery_report
                end

                if not @validity_period.nil? then
                  hash[:'api:validityPeriod'] = @validity_period
                end

                if not @origin.nil? then
                  hash[:'api:origin'] = @origin
                end

                return hash

            end
        end
    end
end
