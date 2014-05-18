module Messagemedia

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

        #
        # Return a hash that can be passed to the Savon SOAP library to
        # represent a recipient. This will be converted to XML of the form:
        #
        #     <api:recipient uid="1">+61422000000</api:recipient>
        #
        # If the recipient does not have a non-nil ID, then the 'uid'
        # attribute will be omitted.
        #
        def to_api_hash
            if @message_id.nil? then
                {
                    :'api:recipient' => @destination_number
                }
            else
                {
                    :'api:recipient' => @destination_number,
                    :'attributes!' => {
                        :'api:recipient' => { 'uid' => @message_id }
                    }
                }
            end
        end

    end  # End class Recipient

end  # End module Messagemedia