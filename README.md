[![Build Status](https://magnum.travis-ci.com/br/cukebot.svg?token=JCgGzvEcw22NfGpdT58q)](https://magnum.travis-ci.com/br/cukebot)
[![Code Climate](https://codeclimate.com/repos/5369d18fe30ba03126000032/badges/3e37984ddc2c954b82b7/gpa.png)](https://codeclimate.com/repos/5369d18fe30ba03126000032/feed)
cukebot
=======

sinatra app that runs integration tests on our platform based on posts received from our deploy bot.

## Intsallation
setup a local db
```
$ brew install postgresql
$ createdb cukebot
```
install gems
```
bundle
```
start server
```
puma
```

To test send a post using an app like postmon once your server is running:
```
localhost:9292/suites?token=YOUR_TOKEN_HERE&text=OGUXYCDI%3A%20Dan%20has%20completed%20a%20deploy%20of%20nikse%2Fmaster-15551-the-web-frontpage-redux%20to%20stag_br5.%20Github%20Hash%20is%2096dd307.%20Took%205%20mins%20and%2025%20secs
```

This is obviously configured for how our deploy messages come through but can be configured to your liking.
