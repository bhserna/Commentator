window.CommentatorTemplates =

  comment: (comment) ->
    """
      <div class="message">
        <p><strong>#{comment.author.name} dijo:</strong></p>
        <p>#{comment.message}</p>
      </div>
      <div id="replies">
      </div>
    """

  comments_form: """
    <label for="comment">Envía un comentario</label>
    <textarea cols="40" id="comment" name="comment" rows="20">
    </textarea>
    <input class="btn" type="submit" value="Enviar">
    """

  reply: (reply) ->
    """
      <div class="message">
        <p><strong>#{reply.author.name} dijo:</strong></p>
        <p>#{reply.message}</p>
      </div>
    """

  replies_form: """
    <textarea id="message" rows="1"></textarea>
    <button>Enviar</button>
    """
