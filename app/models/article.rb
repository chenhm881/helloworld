class Article < ActiveRecord::Base
  attr_accessible :comment, :content, :title
  has_many :comments
end
