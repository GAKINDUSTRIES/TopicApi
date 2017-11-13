# API Template

## Setup

1. Clone this repo
2. Create your `database.yml` and `application.yml` file
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


## Front end configuration for Actioncable, check this [example](https://github.com/rootstrap/Just15-iOS/blob/6f5560c16de1c0a025bd9e7e7196d9ea76d4967b/Just15/Helpers/Constants.swift "Just15-IOS")

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


## Docs

http://docs.rails5apibase.apiary.io
