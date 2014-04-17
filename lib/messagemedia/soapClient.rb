
require 'savon'
require_relative './message.rb'

# class DebugObserver

#   def notify(operation_name, builder, globals, locals)
#   	puts builder
#     nil
#   end

# end

# Savon.observers << DebugObserver.new

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

	def check_replies

		response = @client.call(:check_replies, message: {
			:'api:authentication' => @credentials,
			:'api:requestBody' => {}
			})

		return response.body[:check_replies_response][:result]

	end

	def confirm_replies(reply_ids)

		body = {
			:'api:replies' => reply_ids.map { |reply_id| { :'api:reply' => { :'@receiptId' => reply_id } } }
		}

		response = @client.call(:confirm_replies, message: {
			:'api:authentication' => @credentials,
			:'api:requestBody' => body
			})

		return response.body[:confirm_replies_replies][:result]

	end

	def check_reports

		response = @client.call(:check_reports, message: {
			:'api:authentication' => @credentials,
			:'api:requestBody' => {}
			})

		return response.body[:check_reports_response][:result]

	end

	def confirm_reports(report_ids)

		body = {
			:'api:reports' => reply_ids.map { |report_id| { :'api:report' => { :'@receiptId' => report_id } } }
		}

		response = @client.call(:confirm_reports, message: {
			:'api:authentication' => @credentials,
			:'api:requestBody' => body
			})
		
		return response.body[:confirm_reports_replies][:result]

	end

end
