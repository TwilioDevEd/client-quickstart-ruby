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

  capability = Twilio::Util::Capability.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
  # Create an application sid at 
  # twilio.com/console/phone-numbers/dev-tools/twiml-apps and use it here
  capability.allow_client_outgoing ENV['TWILIO_TWIML_APP_SID']
  capability.allow_client_incoming identity
  token = capability.generate
  
  # Generate the token and send to client
  json :identity => identity, :token => token
end

post '/voice' do
  twiml = Twilio::TwiML::Response.new do |r|
    if params['To'] and params['To'] != ''
      r.Dial callerId: ENV['TWILIO_CALLER_ID'] do |d|
        # wrap the phone number or client name in the appropriate TwiML verb
        # by checking if the number given has only digits and format symbols
        if params['To'] =~ /^[\d\+\-\(\) ]+$/
          d.Number params['To']
        else
          d.Client params['To']
        end
      end
    else
      r.Say "Thanks for calling!"
    end
  end
  
  content_type 'text/xml'
  twiml.text
end
