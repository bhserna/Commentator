# Commentator

Commentator is a javascript(well coffeescript) widget, to add comments
to your Rails app in a simple way.

## Usage

* Adds commentator to your gemfile:

```ruby
gem 'commentator', github: "bhserna/Commentator"
```

* Adds commentator to your manifest in the "application.js"

```javascript
//= require commentator
```

* Use commentator with the coffeescript api:

```coffeescript
# el               - is a jquery element, where the commentator html will be inserted.
# url              - is the url where commentator will send the new comments data.
# comments         - are the comments that commentator will render at initialization.
# comment_template - is a function to be evaluated with a comment as argument.
# reply_template   - is a function to be evaluated with a reply as argument.

new Commentator
  el: $ "section#comments" 
  url: "/comments"
  comments: array_of_comments
  comment_template: JST["comments/comment"]
  reply_template: JST["comments/reply"]
```

* Use commentator as a helper (pending):

```ruby
# el               - is a selector, for a jquery element, where the commentator html will be inserted.
# url              - is the url where commentator will send the new comments data.
# comments         - are the comments that commentator will render at initialization (in json).
# comment_template - is the path to your javascript comment template, it
#                    will be evaluated using JST, like "JST["comments/comment"]
# reply_template   - is the path to your javascript reply template, it
#                    will be evaluated using JST, like "JST["comments/reply"]

<%= commentator(
  url: comments_path,
  comments: @comments.to_json,
  comment_template: "comments/comment",
  reply_template: "comments/form"
) %>
```

## Conventions

* Commentator expects, the replies of every comment and the replies
  path, to be contained in the comment json, as in the next example:

```json
{
  message: "Hello World",
  author: "Norbit",
  replies: [
   { 
     message: "Reply to the world",
     author: "Erviti"
    }  
  ],
  replies_url: "/comments/3/replies"
}
```

All the other attributes are attributes that you can use in your
templates.
