json.extract! channel, :id, :slug, :user_id, :team_id, :created_at, :updated_at
#example: {id: 1, slug: 'dd'.., messages: [{},{}]} //array of messages

#array of messages
json.messages do
  json.array! channel.messages do |message|
    #put in body
    json.extract! message, :id, :body, :user_id, :created_at, :updated_at
  end
end