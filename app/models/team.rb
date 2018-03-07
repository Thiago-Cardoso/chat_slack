class Team < ApplicationRecord
    #has one user
    belongs_to :user 
    #has many talks
    has_many :talks 
    # has much channels
    has_many :channels 
    #required field slug user when create a record team
    validates_presence_of :slug, :user
end
