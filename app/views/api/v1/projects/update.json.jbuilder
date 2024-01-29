json.success true
json.message 'Project has been successfully updated.'
json.project do
  json.merge! @project.attributes.slice('id', 'name', 'description')
end
