class Channel < ApplicationRecord
  #
  has_many :messages, as: :messagable, :dependent => :destroy
  #has one user
  belongs_to :user
  #has one team
  belongs_to :team
  #required a file slug user and team when create a record channel
  validates_presence_of :slug, :team, :user
end
