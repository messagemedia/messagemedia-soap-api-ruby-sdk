[![Gem Version](https://badge.fury.io/rb/messagemedia-ruby.svg)](http://badge.fury.io/rb/messagemedia-ruby)
[![Build Status](https://travis-ci.org/messagemedia/messagemedia-ruby.svg)](https://travis-ci.org/messagemedia/messagemedia-ruby)

# MessageMedia Ruby SDK
This library provides a simple interface for sending and receiving messages using the [MessageMedia SOAP API](http://www.messagemedia.com.au/wp-content/uploads/2013/05/MessageMedia_Messaging_Web_Service.pdf?eacfbb).

If you have any issue using this sample code, or would like to report a defect, you could [create a new Issue](https://github.com/messagemedia/messagemedia-ruby/issues/new) in Github or [Contact us](http://www.messagemedia.com.au/contact-us).

## Installation
The messagemedia-ruby Gem can be installed from Rubygems:

    gem install messagemedia-ruby

## Usage
The following actions have been implemented:

  * sendMessages
  * checkUser
  * checkReplies
  * checkReports
  * confirmReplies
  * confirmReports

### Initialise the client
Initialise the client using your MessageMedia username and password:

    require 'messagemedia-ruby'

    client = Messagemedia::SOAP::Client.new(YOUR_USERNAME, YOUR_PASSWORD)

### Send Messages
To send a single message:

    client.send_message(<TO_NUMBER>, <MESSAGE>, <MESSSAGE_ID>)

To send multiple messages:

    # Construct the first Message object
    message1 = Messagemedia::SOAP::Message.new
    message1.content = "Content of Message"
    message1.delivery_report = true
    message1.origin = "My Company"
    message1.add_recipient(FIRST_MESSAGE_ID, TO_NUMBER)

    # Construct the second Message object
    message2 = Messagemedia::SOAP::Message.new
    message2.content = "Content of Message"
    message2.delivery_report = false
    message2.origin = "My Company"
    message2.add_recipient(SECOND_MESSAGE_ID, TO_NUMBER)

    client.send_messages([message1, message2])

### Other Actions
Check out 'example.rb' in the 'bin' directory to see examples of how you can use the other actions provided by this SDK.

## Contributing
We welcome contributions from our users. Contributing is easy:

  1.  Fork this repo
  2.  Create your feature branch (`git checkout -b my-new-feature`)
  3.  Commit your changes (`git commit -am 'Add some feature'`)
  4.  Push to the branch (`git push origin my-new-feature`)
  5.  Create a Pull Request
