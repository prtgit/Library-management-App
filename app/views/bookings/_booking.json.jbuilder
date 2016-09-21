json.extract! booking, :id, :booking, :cancelled_by, :cancelled, :booked_by, :created_at, :updated_at
json.url booking_url(booking, format: :json)