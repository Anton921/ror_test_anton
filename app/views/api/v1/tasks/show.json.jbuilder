json.success true
json.task do
  json.merge! @task.attributes.slice('id', 'name', 'description', 'status', 'project_id')
end
