#= require "application"

describe "Commentator", ->
  beforeEach ->
    comment_one =
      message:
        "Podemos hacer una escala en la ma\u00f1ana por caf\u00e9?"
      name: "Margarito"
      author:
        thumb_photo_url: "/system/photos/172/thumb/Margarito.jpg?1298321229"
        area_name: "Poemas"

    comment_two =
      message:
        "Mi Comentario"
      name: "Margarito"
      author:
        thumb_photo_url: "/system/photos/172/thumb/Margarito.jpg?1298321229"
        area_name: "Comentarios"

    comments = [comment_one]
    element  = $ "<section>"

    class TestPoster
      constructor: (@comment) ->

      post: (url, data, callback) ->
        callback(@comment)

    @app = new Commentator(
      el: element
      url: "URL"
      comments: comments
      poster: new TestPoster(comment_two)
    )

  describe "at initialization", ->

    it "should have a form view", ->
      expect(@app.form_view.constructor).toEqual Commentator.CommentFormView

    it "should have a comments view", ->
      expect(@app.comments_view.constructor).toEqual Commentator.CommentsView

    it "should have comments", ->
      expect(@app.comments.length).toEqual 1

    it "should have an empty form", ->
      expect(@app.form_view.textarea().val()).toEqual ""

    it "should have a non valid comment", ->
      expect(@app.form_view.is_comment_valid()).toBeFalsy()

    it "should have a disabled button", ->
      expect(@app.form_view.button().is(":disabled")).toBeTruthy()

  describe "after some words", ->

    beforeEach ->
      @app.form_view.textarea().val "some words"
      @app.form_view.textarea().trigger "keyup"

    it "should have a valid comment", ->
      expect(@app.form_view.is_comment_valid()).toBeTruthy()

    it "should have an enabled button", ->
      expect(@app.form_view.button().is(":disabled")).toBeFalsy()

  describe "after click button", ->

    beforeEach ->
      @app.form_view.textarea().val "Some words"
      @app.form_view.button().trigger "submit"

    it "should have a disabled button", ->
      expect(@app.form_view.button().is(":disabled")).toBeTruthy()

  describe "send a comment", ->

    beforeEach ->
      @app.form_view.textarea().val("Mi Comentario")
      @app.form_view.el.trigger("submit")

    it "should have a new comment", ->
      expect(@app.comments.length).toEqual 2
      expect(@app.comments_view.el.html()).toContain "Mi Comentario"

    it "should have a clean textarea", ->
      expect(@app.form_view.textarea().val()).toEqual ""

    it "should have a disabled button", ->
      expect(@app.form_view.button().is(":disabled")).toBeTruthy()

  describe "send an empty comment", ->

    beforeEach ->
      @app.form_view.el.trigger("submit")

    it "should not have a new comment", ->
      expect(@app.comments.length).toEqual 1
