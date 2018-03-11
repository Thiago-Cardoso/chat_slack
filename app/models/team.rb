class Team < ApplicationRecord
    #has one user
    belongs_to :user 
    #has many talks
    has_many :talks 
    # has much channels
    has_many :channels 
    has_many :team_users, dependent: :destroy
    has_many :users, through: :team_users
    #required field slug user when create a record team
    validates_presence_of :slug, :user
    #filter information in string with format
    validates :slug, uniqueness: true, format: { with: /\A[a-zA-Z0-9]+\Z/ }
end
