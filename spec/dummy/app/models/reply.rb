class Reply < ActiveRecord::Base
  belongs_to :comment
  attr_accessible :author_name, :message
end
