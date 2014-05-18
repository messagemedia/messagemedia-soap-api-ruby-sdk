require 'savon'

require_relative 'message.rb'

module Messagemedia

    SOAP_ENDPOINT = "https://soap.m4u.com.au/?wsdl"

    #
    # This class is a light-weight wrapper around the MessageMedia SOAP API.
    #
    class SoapClient

        #
        # Initialize the SOAP client.
        #
        # Your MessageMedia username and password must be provided.
        #
        # These credentials will not be authenticated until an actual request
        # is made using one of the other methods available in this class.
        #
        def initialize(username, password)

            # Store the credentials for use with other methods
            @credentials = {
                :'api:userId' => username,
                :'api:password' => password
            }

            # Create a new Savon-based SOAP client
            @client = Savon.client(wsdl: SOAP_ENDPOINT, log: true)

        end

        #
        # Send a message to a recipient.
        #
        # A destination number (to) is required.
        #
        # The source number (from), message content (content), and message
        # identifier (messageId) are optional. Optional arguments may be
        # omitted by providing nil as an argument.
        #
        # If a message identifier is provided, then it will be returned as
        # part of any replies or delivery reports produced as a result of
        # this message.
        #
        # If a source number is not provided, the message will be sent using
        # the MessageMedia rotary.
        #
        def send_message(from, to, content, messageId)

            # Construct a Message object to represent the message
            message = Message.new
            message.content = content
            message.delivery_report = true
            message.format = FORMAT_SMS
            message.validity_period = 1
            message.origin = from
            message.add_recipient(messageId, to)

            messages = {
                :'@sendMode' => "normal",
                :'api:message' => [ message.to_api_hash ]
            }

            body = {
                :'api:authentication' => @credentials,
                :'api:requestBody' => { :'api:messages' => messages }
            }

            # Make a request to the MessageMedia SOAP service. Note that the
            # message parameter below refers to the body of the SOAP request,
            # not the message object that we constructed above.
            response = @client.call(:send_messages, message: body)
            response.body[:send_messages_response][:result]

        end

        #
        # Send multiple messages using a single request.
        #
        # An array of Message objects must be provided. Unlike the send_message
        # method, this method requires the Message objects to be constructed
        # manually.
        #
        # Constructing an instance of Message is straight-forward:
        #   message = Message.new
        #   message.content = <message content>
        #   message.delivery_report = <true|false>
        #   message.format = <FORMAT_SMS|FORMAT_VOICE>
        #   message.validity_period = 1
        #   message.origin = <source_number>
        #   message.add_recipient(<message ID>, <destination number>)
        #
        def send_messages(messages)

            messages = {
                :'@sendMode' => "normal",
                :'api:message' => messages.map { |m| m.to_api_hash }
            }

            body = {
                :'api:authentication' => @credentials,
                :'api:requestBody' => { :'api:messages' => messages }
            }

            response = @client.call(:send_messages, message: body)
            response.body[:send_messages_response][:result]

        end

        #
        # Retrieve the credit info and other metadata that is available for
        # a MessageMedia account.
        #
        def get_user_info

            body = { :'api:authentication' => @credentials }

            response = @client.call(:check_user, message: body)
            response.body[:check_user_response][:result]

        end

        #
        # Check for, and return, the replies that are available.
        #
        # A maximum number of replies (max_replies) may be specified, in order
        # to limit the size of the response.
        #
        # Note that the same replies will be returned by subsequent calls to
        # this method, unless you also call confirm_replies to confirm that
        # the replies have been received.
        #
        def check_replies(max_replies = nil)

            body = {
                :'api:authentication' => @credentials,
                :'api:requestBody' => {}
            }

            if not max_replies.nil? then
                body[:'api:requestBody'][:'api:maxReplies'] = max_replies
            end

            response = @client.call(:check_replies, message: body)
            response.body[:check_replies_response][:result]

        end

        #
        # Confirm that replies have been received.
        #
        # An array of reply IDs (reply_ids) must be provided. Each of the IDs
        # in this array should correspond to a reply that was received using
        # the check_replies method.
        #
        def confirm_replies(reply_ids)

            body = {
                :'api:authentication' => @credentials,
                :'api:requestBody' => {
                    :'api:replies' => reply_ids.map do |reply_id|
                        { :'api:reply' => { :'@receiptId' => reply_id } }
                    end
                }
            }

            response = @client.call(:confirm_replies, message: body)
            response.body[:confirm_replies_response][:result]

        end

        #
        # Check for, and return, the Delivery Reports that are available.
        #
        # A maximum number of reports (max_reports) may be specified, in order
        # to limit the size of the response.
        #
        # Note that the same delivery reports will be returned by subsequent
        # calls to this method, unless you also call confirm_replies to confirm
        # that the replies have been received.
        #
        # Note also that Delivery Reports are often called Delivery Receipts,
        # and the terms can be used interchangeably.
        #
        def check_reports(max_reports = nil)

            body = {
                :'api:authentication' => @credentials,
                :'api:requestBody' => {}
            }

            if not max_reports.nil? then
                body[:'api:requestBody'][:'api:maxReports'] = max_reports
            end

            response = @client.call(:check_reports, message: body)
            response.body[:check_reports_response][:result]

        end

        #
        # Confirm that Delivery Reports have been received.
        #
        # An array of delivery report IDs (report_ids) must be provided. Each
        # of the IDs in this array should correspond to a Delivery Report that
        # was received using the check_reports method.
        #
        def confirm_reports(report_ids)

            body = {
                :'api:authentication' => @credentials,
                :'api:requestBody' => {
                    :'api:reports' => reply_ids.map do |report_id|
                        { :'api:report' => { :'@receiptId' => report_id } }
                    end
                }
            }

            response = @client.call(:confirm_reports, message: body)
            response.body[:confirm_reports_replies][:result]

        end

    end  # End class SoapClient

end  # End module Messagemedia
