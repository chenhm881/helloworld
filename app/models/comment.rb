class Comment < ActiveRecord::Base
  attr_accessible :content, :article_id
  belongs_to :article

end
