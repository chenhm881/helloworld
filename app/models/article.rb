class Article < ActiveRecord::Base
  attr_accessible :comment, :content, :title
end
