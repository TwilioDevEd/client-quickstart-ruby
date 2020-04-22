require 'twilio-ruby'
require 'sinatra'
require 'sinatra/json'
require 'dotenv'
require 'faker'

# Load environment configuration
Dotenv.load

# Render home page
get '/' do
  File.read(File.join('public', 'index.html'))
end

# Generate a token for use in our Video application
get '/token' do
  # Create a random username for the client
  identity = Faker::Internet.user_name.gsub(/[^0-9a-z_]/i, '')

  capability = Twilio::JWT::ClientCapability.new ENV['TWILIO_ACCOUNT_SID'],
    ENV['TWILIO_AUTH_TOKEN']
  # Create an application sid at
  # twilio.com/console/phone-numbers/dev-tools/twiml-apps and use it here
  outgoing_scope = Twilio::JWT::ClientCapability::OutgoingClientScope.new(ENV['TWILIO_TWIML_APP_SID'])
  incoming_scope = Twilio::JWT::ClientCapability::IncomingClientScope.new('test-client-name')
  capability.add_scope(outgoing_scope)
  capability.add_scope(incoming_scope)

  # Generate the token and send to client
  json :identity => identity, :token => capability.to_jwt
end

post '/voice' do
  twiml = Twilio::TwiML::VoiceResponse.new do |r|
    if params['To'] and params['To'] != ''
      r.dial(caller_id: ENV['TWILIO_CALLER_ID']) do |d|
        # wrap the phone number or client name in the appropriate TwiML verb
        # by checking if the number given has only digits and format symbols
        if params['To'] =~ /^[\d\+\-\(\) ]+$/
          d.number(params['To'])
        else
          d.client(params['To'])
        end
      end
    else
      r.say("Thanks for calling!")
    end
  end

  content_type 'text/xml'
  twiml.to_s
end
