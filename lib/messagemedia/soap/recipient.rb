module Messagemedia

    module SOAP

        #
        # This class is a light-weight wrapper around the Recipient structure used
        # by the MessageMedia SoapClient interface.
        #
        class Recipient

            attr_accessor :message_id, :destination_number

            #
            # Initialize an empty Recipient object.
            #
            # This object represents a single recipient of a message, and allows
            # an optional message ID (message_id) to be assigned to the message
            # that will be sent to that recipient.
            #
            # A destination number (destination_number) must be provided
            #
            def initialize(message_id, destination_number)
                @message_id = message_id
                @destination_number = destination_number
            end

        end
    end
end