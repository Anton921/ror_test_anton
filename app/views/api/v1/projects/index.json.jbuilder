json.success true
json.projects @projects do |project|
  json.merge! project.attributes.slice(
    'id',
    'name'
  )
end
