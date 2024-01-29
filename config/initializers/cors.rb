Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:3000'
    resource '*',
      headers: :any,
      expose: ["Authorization"],
      methods: [:get, :patch, :put, :delete, :post, :show, :head, :options],
      credentials: true
  end
end
