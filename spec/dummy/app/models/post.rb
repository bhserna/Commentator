class Post < ActiveRecord::Base
  attr_accessible :body, :title
  has_many :comments

  def comments_commentator_json(context)
    comments.map { |comment| comment.commentator_hash(context) }.to_json
  end
end
