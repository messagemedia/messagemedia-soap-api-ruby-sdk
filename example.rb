
require './mmsoap/soapClient.rb'

USER_ID			= 	"<user id>";
PASSWORD 		= 	"<password>";
FROM_NUMBER 	= 	"+61412345678";
TO_NUMBER	 	= 	"+61412345678";

##
# Private method used for rendering the results to the console screen.
def display_result(result)

	puts "Messages sent #{result[:'@sent']}"
	puts "Messages failed #{result[:'@failed']}"
	puts "Messages scheduled #{result[:'@scheduled']}"

	if not result[:errors].nil? then
		puts result.errors
	end

end

##
# Example demonstrates how to quickly send a single message with the default
# settings.
def send_message

    puts "EXECUTING SEND MESSAGE..."
    messageId = 1234567890;

    client = MessageMediaSoapClient.new(USER_ID, PASSWORD)
    result = client.send_message(FROM_NUMBER, TO_NUMBER, "Test Message", messageId)
    display_result result

end

##
# Example shows how to send a batch of messages. It's possible to send
# multiple individual messages in a single batch.
def send_multiple_messages

	puts "EXECUTING SEND MULTIPLE MESSAGES..."

    client = MessageMediaSoapClient.new(USER_ID, PASSWORD)

    # Construct the message
    message1 = Message.new
    message1.content = "Content of Message 1 to Recipient 1"
    message1.delivery_report = true
    message1.format = FORMAT_SMS
    message1.validity_period = 1
    # (Optional) This attribute specifies a sequence number that is assigned to the message and is used to identify the message if an error occurs. Each message error in the response will specify the sequence number of the message that caused the error. Sequence numbers should be unique within the request. 1 to 2147483647.
    message1.sequence_number = 1
    # (Optional) This element specifies the message source address. The specified address will be used wherever possible, however due to limitations with various carriers, legislation etc, the final message is not guaranteed to come from the specified address.
    message1.origin = "Origin_1"
    message1.add_recipient(1234567890, TO_NUMBER)

    # Construct the message
    message2 = Message.new
    message2.content = "Content of Message 2 to Recipient 2"
    message2.delivery_report = true
    message2.format = FORMAT_SMS
    message2.validity_period = 1
    # (Optional) This attribute specifies a sequence number that is assigned to the message and is used to identify the message if an error occurs. Each message error in the response will specify the sequence number of the message that caused the error. Sequence numbers should be unique within the request. 1 to 2147483647.
    message2.sequence_number = 1
    # (Optional) This element specifies the message source address. The specified address will be used wherever possible, however due to limitations with various carriers, legislation etc, the final message is not guaranteed to come from the specified address.
    message2.origin = "Origin_2"
    message2.add_recipient(234567890, TO_NUMBER)

    result = client.send_messages([ message1, message2 ])
    display_result result

end

##
# Example demonstrates how to get account and credit remaining information.
def check_user_info

	puts "EXECUTING CHECK USER INFO..."

    client = MessageMediaSoapClient.new(USER_ID, PASSWORD)
    user_info = client.get_user_info

    account_details = user_info[:account_details]
    puts "Credit limit: #{account_details[:'@credit_limit']}"
    puts "Remaining credits: #{account_details[:'@credit_remaining']}"
    puts "Account type: #{account_details[:'@type']}"

end

check_user_info
send_message
send_multiple_messages
