json.extract! room, :id, :number, :status, :building, :size, :created_at, :updated_at
json.url room_url(room, format: :json)