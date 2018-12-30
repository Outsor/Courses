json.extract! notice, :id, :name, :content, :created_at, :updated_at
json.url notice_url(notice, format: :json)