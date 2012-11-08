class window.CommentatorParams

  constructor: (@args) ->

  el: ->
    @args.el

  url: ->
    @args.url

  poster: ->
    @args.poster || new CommentatorPoster

  comments: ->
    @args.comments || @el.data "comments"

  reply_link_name: ->
    @args.reply_link_name || "Comment"

  display_form: ->
    if @args.display_form? then @args.display_form else true

  comment_template: ->
    @args.comment_template || CommentatorTemplates.comment

  reply_template: ->
    @args.reply_template   || CommentatorTemplates.reply

  comments_form_template: ->
    @args.comments_form_template || CommentatorTemplates.comments_form

  replies_form_template: ->
    @args.replies_form_template  || CommentatorTemplates.replies_form

  on_comment: ->
    @args.on_comment || @_no_op

  on_reply: ->
    @args.on_comment || @_no_op

  _no_op: ->
