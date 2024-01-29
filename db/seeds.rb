10.times do
  Project.create(
    name: Faker::App.name,
    description: Faker::Lorem.sentence
  )
end

projects = Project.all

50.times do
  Task.create(
    name: Faker::Lorem.word,
    description: Faker::Lorem.sentence,
    status: rand(3),
    project: projects.sample
  )
end
