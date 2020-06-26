# frozen_string_literal: true

require File.expand_path('spec_helper.rb', __dir__)

describe 'app' do
  describe 'get /' do
    it 'renders index.html page' do
      twilio_sdk = '<script type="text/javascript"' \
                   ' src="//sdk.twilio.com/js/client/releases/1.10.1/' \
                   'twilio.js"></script>'
      jquery_script = '<script src="//ajax.googleapis.' \
                      'com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>'

      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('id="ringtone-devices"')
      expect(last_response.body).to include('id="speaker-devices"')
      expect(last_response.body).to include('id="get-devices"')
      expect(last_response.body).to include('<button id="button-call">Call</button>')
      expect(last_response.body).to include('<button id="button-hangup">Hangup</button>')
      expect(last_response.body).to include('<div id="log"></div>')
      expect(last_response.body).to include(jquery_script)
      expect(last_response.body).to include(twilio_sdk)
    end
  end

  describe 'get /token' do
    it 'generates a token' do
      get '/token'
      expect(JSON.parse(last_response.body).keys).to contain_exactly('identity', 'token')
    end
  end

  describe 'post /voice' do
    context 'when a phone number is sent' do
      it 'responds with Number tag' do
        post '/voice', To: '+1234567890'
        expect(last_response.body).to include('<Number>+1234567890</Number>')
      end
    end

    context 'when a string is sent ' do
      it 'responds with Number tag' do
        post '/voice', To: 'client'
        expect(last_response.body).to include('<Client>client</Client>')
      end
    end

    context 'when no parameter is sent ' do
      it 'responds with Number tag' do
        post '/voice'
        expect(last_response.body).to include('<Say>Thanks for calling!</Say>')
      end
    end
  end
end
