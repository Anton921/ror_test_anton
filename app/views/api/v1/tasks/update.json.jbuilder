json.success true
json.message 'Task has been successfully updated.'
json.task do
  json.merge! @task.attributes.slice('id', 'name', 'description', 'status', 'project_id')
end
