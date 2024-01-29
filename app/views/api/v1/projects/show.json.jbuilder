json.success true
json.project do
  json.merge! @project.attributes.slice('id', 'name', 'description')
end
