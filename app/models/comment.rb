class Comment < ActiveRecord::Base
  attr_accessible :content, :article_id, :answer
  belongs_to :article

end
