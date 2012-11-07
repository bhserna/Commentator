module CommentatorHelper
  def commentator args
    commentator_tag = content_tag :div, "", id: "commentator"

    commentator_tag + javascript_tag do
      "jQuery(function(){
        new Commentator({
          el: $('div#commentator'),
          url: '#{args[:url]}',
          comments: #{args[:comments]},
          comment_template: JST['#{args[:comment_template]}'],
          reply_template: JST['#{args[:reply_template]}']
        });
      });".html_safe
    end
  end
end
