# Twilio Client Quickstart for Ruby

This application should give you a ready-made starting point for writing your
own voice apps with Twilio Client. Before we begin, we need to collect
all the config values we need to run the application:

| Config&nbsp;Value  | Description |
| :-------------  |:------------- |
Account&nbsp;SID | Your primary Twilio account identifier - find this [in the console here](https://www.twilio.com/console).
Auth&nbsp;Token | Used to authenticate - [just like the above, you'll find this here](https://www.twilio.com/console).
TwiML&nbsp;App&nbsp;SID | The TwiML application with a voice URL configured to access your server running this app - create one [in the console here](https://www.twilio.com//console/phone-numbers/dev-tools/twiml-apps). Also, you will need to configure the Voice "REQUEST URL" on the TwiML app once you've got your server up and running.
Twilio&nbsp;Phone&nbsp;# | A Twilio phone number in [E.164 format](https://en.wikipedia.org/wiki/E.164) - you can [get one here](https://www.twilio.com/console/phone-numbers/incoming)

## Setting Up The Ruby (Sinatra) Application

1. Create a configuration file for your application:

    ```bash
    cp .env.example .env
    ```

2. Edit `.env` with the four configuration parameters we gathered from above.

3. Next, we need to install our depenedencies:

    ```bash
    bundle install
    ```

4. Run the application using the `ruby` command.

    ```bash
    bundle exec ruby app.rb
    ```

5. Your application should now be running at [http://localhost:4567](http://localhost:4567). 

6. [Download and install ngrok](https://ngrok.com/download)

7. Run ngrok:

    ```bash
    ngrok http 4567
    ```

8. When ngrok starts up, it will assign a unique URL to your tunnel.
It might be something like `https://asdf456.ngrok.io`. Take note of this.

9. [Configure your TwiML app](https://www.twilio.com//console/phone-numbers/dev-tools/twiml-apps)'s
Voice "REQUEST URL" to be your ngrok URL plus `/voice`. For example:

    ![screenshot of twiml app](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/TwilioClientRequestUrl.original.png)

You should now be ready to rock! Make some phone calls.
Open it on another device and call yourself. Note that Twilio Client requires
WebRTC enabled browsers, so Edge and Internet Explorer will not work for testing.
We'd recommend Google Chrome or Mozilla Firefox instead.

![screenshot of phone app](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/TwilioClientQuickstart.original.png)

## License

MIT
