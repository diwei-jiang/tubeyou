json.array!(@videos) do |video|
  json.extract! video, :name, :description, :url
  json.url video_url(video, format: :json)
end
