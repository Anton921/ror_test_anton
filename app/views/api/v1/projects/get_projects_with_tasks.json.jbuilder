json.success true
json.projects @projects do |project|
  json.merge! project.attributes.slice(
    'id',
    'name'
  )
  json.tasks project.tasks do |task| 
    json.merge! task.attributes.slice('id', 'name', 'status')
  end
end
