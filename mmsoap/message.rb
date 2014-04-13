
require_relative './recipient.rb'

FORMAT_SMS = "SMS"
FORMAT_VOICE = "voice"

class Message

	attr_accessor :sequence_number, :origin, :recipients, :content, :validity_period,
				  :format, :delivery_report

	def initialize
		@recipients = []
		@deliveryReport = true
		@validityPeriod = 1
		@sequenceNumber = 0
	end

	def add_recipient(id, number)
		@recipients.push(Recipient.new(id, number))
	end

	def to_api_hash
		return {
			:'@format' => @format,
			:'@sequenceNumber' => @sequence_number,
			:'api:origin' => @origin,
			:'api:deliveryReport' => @delivery_report,
			:'api:validityPeriod' => @validity_period,
			:'api:recipients' => {
				:attributes! => { recipient: @recipients.map { |r| r.id } },
				:'api:recipient' => @recipients.map { |r| r.number }
			},
			:'api:content' => @content
		}
	end

end