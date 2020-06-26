# frozen_string_literal: true

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
  # Required for any Twilio Access Token
  account_sid = ENV['TWILIO_ACCOUNT_SID']
  api_key = ENV['API_KEY']
  api_secret = ENV['API_SECRET']

  # Required for Voice
  outgoing_application_sid = ENV['TWILIO_TWIML_APP_SID']

  # Create a random username for the client
  identity = Faker::Internet.user_name.gsub(/[^0-9a-z_]/i, '')

  # Create Voice grant for our token
  grant = Twilio::JWT::AccessToken::VoiceGrant.new
  grant.outgoing_application_sid = outgoing_application_sid

  # Optional: add to allow incoming calls
  grant.incoming_allow = true

  # Create an Access Token
  token = Twilio::JWT::AccessToken.new(
    account_sid,
    api_key,
    api_secret,
    [grant],
    identity: identity
  )

  # Generate the token and send to client
  json :identity => identity, :token => token.to_jwt
end

post '/voice' do
  twiml = Twilio::TwiML::VoiceResponse.new do |r|
    if params['To'] && params['To'] != ''
      r.dial(caller_id: ENV['TWILIO_CALLER_ID']) do |d|
        # wrap the phone number or client name in the appropriate TwiML verb
        # by checking if the number given has only digits and format symbols
        if params['To'] =~ /^[\d\+\-\(\) ]+$/
          d.number(params['To'])
        else
          d.client identity: params['To']
        end
      end
    else
      r.say(message: "Thanks for calling!")
    end
  end

  content_type 'text/xml'
  twiml.to_s
end
