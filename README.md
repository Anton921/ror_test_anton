* Clone the project.

* Execute bundle i, rails db:create, rails db:migrate, and rails db:seed.

* Create a file named .env and add the following line with the value obtained from the command openssl rand -hex 32: DEVISE_JWT_SECRET_KEY=your_value_here.

* Before making requests to tasks and projects, create a user and log in. Example:
POST -> http://127.0.0.1:3000/api/v1/signup:
{
    "user": {
        "email": "example@gmail.com",
        "password": "123456"
    }
}
Use a similar request for login, but send it to POST -> http://127.0.0.1:3000/api/v1/login.
For all other requests, include the Bearer token from the authorization in the header.

* Redis is used for caching, ensure it is installed and running.

* Run tests: bundle exec rspec.

