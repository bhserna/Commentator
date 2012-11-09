#= require application

class Replies.TestRepliesPoster
  constructor: ->
    @reply =
      id: 1
      message:
        "Mi Respuesta uno"
      author:
        name: "Margarito"
        thumb_photo_url: "/system/photos/172/thumb/Margarito.jpg?1298321229"
        area_name: "Margaritas"

  post: (url, data, callback) ->
    @reply.message = data.message
    callback(@reply)

describe "Replies", ->
  beforeEach ->
    reply_one =
      id: 1
      message:
        "Mi Respuesta uno"
      author:
        name: "Margarito"
        thumb_photo_url: "/system/photos/172/thumb/Margarito.jpg?1298321229"
        area_name: "Margaritas"

    comment_one =
      id: 1
      message:
        "Mi Comentario"
      name: "Margarito"
      author:
        thumb_photo_url: "/system/photos/172/thumb/Margarito.jpg?1298321229"
        area_name: "Margaritas"
      replies: [reply_one]
      replies_url: "/replies"

    @commentator =
      on_comment_render: (->)
      on_reply_render: (->)
      comment_template: CommentatorTemplates.comment

    comment_view = new Commentator.CommentItemView(@commentator, comment_one)
    comment_view.render()

    spyOn(@commentator, "on_reply_render")

    args =
      el: comment_view.replies_el()
      comment: comment_one
      poster: new Replies.TestRepliesPoster
      reply_template: CommentatorTemplates.reply
      replies_form_template: CommentatorTemplates.replies_form
      reply_link_name: "Comment"
      display_form: true
      on_reply_render: @commentator.on_reply_render

    @app = new Replies args

  describe "at initialization", ->

    it "should have a link to make a new reply", ->
      expect(@app.el.html()).toContain "Comment"

    it "should have replies", ->
      expect(@app.replies.length).toEqual 1
      expect(@app.el.text()).toContain "Mi Respuesta uno"

  describe "clicking the reply link", ->

    beforeEach ->
      @app.reply_link.trigger "click"

    it "shows the text area to make a reply", ->
      expect(@app.el.html()).toContain "textarea"

    it "has a textarea of one row", ->
      expect(@app.form_view.textarea().attr "rows").toEqual "1"

    it "shows a button to send the reply", ->
      expect(@app.form_view.button().text()).toEqual "Enviar"

    it "doesn't have a link to make a new replay", ->
      expect(@app.el.html()).not.toContain "Comment"

    it "should have a disabled button", ->
      expect(@app.form_view.button().is(":disabled")).toBeTruthy()

  describe "after some words", ->

    beforeEach ->
      @app.reply_link.trigger "click"
      @app.form_view.textarea().val "some words"
      @app.form_view.textarea().trigger "keyup"

    it "should have a valid message", ->
      expect(@app.form_view.is_message_valid()).toBeTruthy()

    it "should have an enabled button", ->
      expect(@app.form_view.button().is(":disabled")).toBeFalsy()

  describe "after click send", ->

    beforeEach ->
      app = replies_form_template: CommentatorTemplates.replies_form
      @form = new Replies.ReplyFormView(app)
      @form.textarea().val "Mi Respuesta dos"
      @form.textarea().trigger "keyup"
      @form.button().trigger "submit"

    it "should have a disabled button", ->
      expect(@form.button().is(":disabled"))

  describe "send a reply", ->

    beforeEach ->
      @app.reply_link.trigger "click"
      @app.form_view.textarea().val "Mi Respuesta dos"
      @app.form_view.el.trigger "submit"

    it "should have a new reply", ->
      expect(@app.replies.length).toEqual 2
      expect(@app.el.html()).toContain "Mi Respuesta dos"

    it "should have no textarea", ->
      expect(@app.form_view.el).toBeFalsy()

    it "should have a link to make a new reply", ->
      expect(@app.el.html()).toContain "Comment"

    it "calls the on reply render callback", ->
      expect(@commentator.on_reply_render).toHaveBeenCalled()

  describe "send an empty comment", ->

    beforeEach ->
      @app.reply_link.trigger "click"
      @app.form_view.el.trigger "submit"

    it "should not ave a new comment", ->
      expect(@app.replies.length).toEqual 1
