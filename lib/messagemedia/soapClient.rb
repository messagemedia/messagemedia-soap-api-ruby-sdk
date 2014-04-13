
require 'savon'
require_relative './message.rb'

SOAP_ENDPOINT = "https://soap.m4u.com.au/?wsdl"

class MessageMediaSoapClient

	def initialize(user_id, password)
		@credentials = { :'api:userId' => user_id, :'api:password' => password }
		@client = Savon.client(wsdl: SOAP_ENDPOINT)
	end

	def send_message(from, to, content, messageId)

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

		response = @client.call(:send_messages, message: body)
		response.body[:send_messages_response][:result]

	end

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

	def get_user_info

		response = @client.call(:check_user, message: { :'api:authentication' => @credentials })
		return response.body[:check_user_response][:result]

	end

end
