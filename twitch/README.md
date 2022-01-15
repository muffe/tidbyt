# Tidbyt Twitch Subscriber Counter

This is an app to show your current Twitch.tv subscribers on your tidbyt.  
![App preview](https://i.imgur.com/ekw3yQy.gif)
## Installation

Use the [Tidbyt Push API](https://tidbyt.dev/docs/tidbyt-api/b3A6MTYyODkwOA-push-to-a-device) to install the app.

## Usage
Change the API Info at the top of the script, after that use [pixlet](https://github.com/tidbyt/pixlet) to render/test the app.
```python
TWITCH_USERNAME = "CHANGE_ME"
TWITCH_API_SECRET = "CHANGE_ME"
TWITCH_API_CLIENT_ID = "CHANGE_ME"
```

## Known Issues

If you have more than 100 subs it's not going to display more than the last 100 subs.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)
