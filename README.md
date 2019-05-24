# Topic API

Topic API is a ruby on rails api created to match people that like to chat with others about a certain topic.

## Basic Flow
  1. A user creates a Target
  2. Another user creates a target that is the same topic as the first one and is inside the distance specified.
  3. A match is created and they are now able to chat.

## Features

- Users
  - Create account
  - Login with mail
  - Login with facebook
  - Update account
  - Reset password
- Target
  - Create target (Maximum of 10)
  - List all created targets
  - Delete target
- Conversations
  - List conversations
  - Receive notifications when a conversation that involves me was created
  - Show unread messages indicator
- Messages
  - Receive notifications when someone messages me
  - List messages of a conversation

## Interesting features

- DeviseTokenAuth: Can you imagine a world without Devise? I can't
- Postgis: Postgres extension is included to efficiently connect people with other people nearby.
- ActionCable: Implemented for people to be able to chat with others.
- Koala: Got bless to the one who invented OAuth2. This help us to login using Facebook within seconds.
- ActiveAdmin: Easy interface to play with.

And much more amazing stuff! Check out the code.

## Setup

1. Clone this repo
2. Create your `database.yml` and `application.yml` file. Don't forget to set your adapter as `postgis` instead of `postgres`
3. `bundle install`
4. Generate a secret key with `rake secret` and paste this value into the `application.yml`
5. `rake db:create`
6. `rake db:migrate`
7. `rails s`

## Optional configuration

- Set your [frontend URL](https://github.com/cyu/rack-cors#origin) in `config/initializers/rack_cors.rb`
- Set your mail sender in `config/initializers/devise.rb`
- Decrease `token_lifespan` in `config/initializers/devise_token_auth.rb` if the frontend is a Web-app.
- Remove Facebook code with `git revert a8319a37ab8d038399a7a6bd74fe3869bb3f3ddc`
- Config your timezone accordingly in `application.rb`.


## Front end configuration for Actioncable

-  origin: 'target-app'
-  chatChannel: 'ChatChannel'
-  chatChannelAction: 'send_message'
-  roomIdentifier: 'match_conversation_id'
-  url: 'wss://{api-url}/api/v1/cable'

### Message format send
  ```
  {
    "action": "send_message",
    "content": "text",
    "match_conversation_id": 1
  }
  ```

### Message format receive
  ```
  {
    content: "Hi!",
    action: 'new_message',
    user: {
      avatar: {
        url: "/topic/icon/1/eb7bf9f2-62be-451c-af5b-5b41150eef1c.jpg"
      }
    },
    user_id: 1
    date: 2017-11-15T13:34:04Z
  }
  ```

## Demo

Want to give it a try? Here's a [demo](https://topic-api.herokuapp.com/admin) for you to play with.

Check out the `seeds` for credentials

## Api Docs

https://topicapi1.docs.apiary.io/#

## Code quality

With `rake code_analysis` you can run the code analysis tool, you can omit rules with:

- [Rubocop](https://github.com/bbatsov/rubocop/blob/master/config/default.yml) Edit `.rubocop.yml`
- [Reek](https://github.com/troessner/reek#configuration-file) Edit `config.reek`
- [Rails Best Practices](https://github.com/flyerhzm/rails_best_practices#custom-configuration) Edit `config/rails_best_practices.yml`
- [Brakeman](https://github.com/presidentbeef/brakeman) Run `brakeman -I` to generate `config/brakeman.ignore`
- [Bullet](https://github.com/flyerhzm/bullet#whitelist) You can add exceptions to a bullet initializer or in the controller
