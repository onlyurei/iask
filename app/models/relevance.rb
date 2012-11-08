class Relevance < ActiveRecord::Base
  belongs_to :entry
  belongs_to :keyword
  
  attr_accessible :entry_id, :keyword_id, :value
end
