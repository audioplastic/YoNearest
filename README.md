YoNearest
==========

YoNearest sends an @Yo back to the user immediately showing the location of the nearest whatever. There is a live example running on Heroku, "YOATM", for you to try. Send YOATM an @Yo and it will send you the location of the nearest ATM.

To get this up and running you need to place a file in the app directory called `tokens.rb`. This must be populated with the API token for your Yo account in a variable called `YoToken`, and the API token for your Google Places account in a variable called `GoogleToken`.

The name of the endpoint describes the thing you want to locate. For example, to find the nearest ATM, the callback URI looks like this . . 

http://myexamplesite.com/v1/loc/atm?username=USERNAME&location=42.360091;-72.094155

You can find a complete list of place types here.

https://developers.google.com/places/documentation/supported_types

To test the code, I recommend running `foreman` with `rerun`, then connecting to localhost:5000 to test with curl, or via ngrok to test with Yo directly.

