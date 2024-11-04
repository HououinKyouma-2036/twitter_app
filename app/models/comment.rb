class Comment < ApplicationRecord
  include Visible
  include ElectionSafe
  
  belongs_to :post
  belongs_to :user
  validates :user, presence: true
end