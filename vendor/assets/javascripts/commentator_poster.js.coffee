class window.CommentatorPoster
  post: (url, data, callback) ->
    $.ajax
      type: "POST"
      url: url
      data: data
      success: (json) =>
        callback(json)
