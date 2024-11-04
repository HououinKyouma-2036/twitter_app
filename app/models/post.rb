class Post < ApplicationRecord
  include Visible
  include ElectionSafe
  
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
end