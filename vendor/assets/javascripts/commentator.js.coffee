#= require "commentator_templates"

class window.Commentator

  constructor: (args) ->
    @el  = args.el
    @url = args.url
    @poster   = args.poster   || new Commentator.Poster
    @comments = args.comments || @fetch_comments()
    @reply_link_name = args.reply_link_name || "Comment"

    @set_display_form(args)
    @set_templates(args)

    @el.delegate ".comments_form", "submit", @add_comment

    @render_comments()
    @render_form() if @display_form and @url?

  set_display_form: (args) ->
    if args.display_form?
      @display_form = args.display_form
    else
      @display_form = true

  set_templates: (args) ->
    @comment_template = args.comment_template || CommentatorTemplates.comment
    @reply_template   = args.reply_template   || CommentatorTemplates.reply
    @comments_form_template = args.comments_form_template || CommentatorTemplates.comments_form
    @replies_form_template  = args.replies_form_template  || CommentatorTemplates.replies_form

  fetch_comments: ->
    @el.data "comments"

  render_comments: ->
    @comments_view = new Commentator.CommentsView(this, @comments)
    @el.append @comments_view.render()

  render_form: ->
    @form_view = new Commentator.CommentFormView(this)
    @el.append @form_view.render()

  add_comment: (e) =>
    e.preventDefault()
    if @form_view.is_comment_valid()
      @_save_comment()

  _save_comment: ()->
    data =
      message: @form_view.comment()

    @poster.post @url, data, (json) =>
      @comments.push json
      @comments_view.add_comment(json)
      @form_view.clean()

class Commentator.CommentFormView
  constructor: (@app) ->
    @el = $ "<form>"
    @el.addClass "comments_form"
    @el.delegate "textarea", "keyup", @change_state
    @el.submit @disable
    @template = @app.comments_form_template

  render: ->
    @el.html @template
    @disable()
    @el

  disable: =>
    @button().attr "disabled", true

  enable: =>
    @button().attr "disabled", false

  change_state: =>
    if @is_comment_valid()
      @enable()
    else
      @disable()

  is_comment_valid: ->
    @comment() != ""

  comment: ->
    @textarea().val()

  clean: ->
    @textarea().val ""

  textarea: ->
    @el.find "textarea"

  button: ->
    @el.find ".btn"

class Commentator.CommentItemView
  constructor: (@app, @comment) ->
    @el = $ "<div class='comment'>"
    @template = @app.comment_template

  render: ->
    @el.html @template(@comment)
    @el

  add_replies: ->
    @replies_app = new Replies
      el: @replies_el()
      comment: @comment
      reply_template: @app.reply_template
      reply_link_name: @app.reply_link_name
      replies_form_template: @app.replies_form_template
      display_form: @app.display_form

  replies_el: ->
    @el.find "#replies"

class Commentator.CommentsView
  constructor: (@app, @comments) ->
    @el = $ "<div id='comments'>"

  render: ->
    for comment in @comments
      @add_comment comment
    @el

  add_comment: (comment) ->
    comment_view = new Commentator.CommentItemView(@app, comment)
    @el.append comment_view.render()
    comment_view.add_replies()

class Commentator.Poster
  post: (url, data, callback) ->
    $.ajax
      type: "POST"
      url: url
      data: data
      success: (json) =>
        callback(json)

class window.Replies

  constructor: (args) ->
    @el = args.el
    @comment = args.comment
    @replies = @comment.replies || []
    @reply_link_name = args.reply_link_name
    @reply_template = args.reply_template
    @replies_form_template = args.replies_form_template
    @url = @comment.replies_url
    @display_form = args.display_form

    @poster  = args.poster || new Commentator.Poster

    @el.delegate "[data-link='reply']", "click", @render_form
    @el.delegate "form", "submit", @add_reply

    @render_replies()

    if @display_form and @url?
      @add_reply_link()

  add_reply_link: ->
    @reply_link = $ "<a data-link='reply' href='#'>#{@reply_link_name}</a>"
    @el.append @reply_link

  remove_reply_link: ->
    @reply_link.remove()
    @reply_link = null

  render_replies: ->
    @replies_view = new Replies.RepliesView(this, @replies)
    @el.append @replies_view.render()

  render_form: (e) =>
    e.preventDefault(e)
    @remove_reply_link()
    @form_view = new Replies.ReplyFormView(this)
    @el.append @form_view.render()

  add_reply: (e) =>
    e.preventDefault()
    if @form_view.is_message_valid()
      @_save_message()

  _save_message: ->
    data =
      message: @form_view.message()

    @poster.post @url, data, (json) =>
      @replies.push json
      @replies_view.add_reply(json)
      @form_view.remove()
      @add_reply_link()

class Replies.RepliesView
  constructor: (@app, @replies) ->
    @el = $ "<div id='replies_list'>"

  render: ->
    for reply in @replies
      @add_reply reply
    @el

  add_reply: (reply) ->
    view = new Replies.ReplyItemView(@app, reply)
    @el.append view.render()

class Replies.ReplyFormView
  constructor: (@app) ->
    @el = $ "<form>"
    @template = @app.replies_form_template
    @el.delegate "textarea", "click", @initialize_text_expander
    @el.delegate "textarea", "keyup", @change_state
    @el.submit @disable

  render: ->
    @el.html @template
    @disable()
    @el

  disable: =>
    @button().attr "disabled", true

  enable: ->
    @button().attr "disabled", false

  change_state: =>
    if @is_message_valid()
      @enable()
    else
      @disable()

  textarea: ->
    @el.find "textarea"

  button: ->
    @el.find "button"

  message: ->
    @textarea().val()

  clean: ->
    @textarea().val("")

  remove: ->
    @el.remove()
    @el = null

  is_message_valid: ->
    @message() != ""

  initialize_text_expander: =>
    MIN_HEIGHT = 18
    @textarea().TextAreaExpander(MIN_HEIGHT)

class Replies.ReplyItemView
  constructor: (@app, @reply) ->
    @el = $ "<div class='reply'>"
    @template = @app.reply_template

  render: ->
    @el.html @template(@reply)
    @el
