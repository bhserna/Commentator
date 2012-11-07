class Comment < ActiveRecord::Base
  belongs_to :post
  has_many :replies
  attr_accessible :autor_name, :message

  def commentator_hash(context)
    as_json.merge(
      replies: replies.as_json,
      replies_url: context.reply_comment_path(id)
    )
  end

  def commentator_json(context)
    commentator_hash(context).to_json
  end
end
