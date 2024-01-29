json.success true
json.tasks @tasks do |task|
  json.merge! task.attributes.slice(
    'id',
    'name',
    'status'
  )
end
