# README

This repository contains the solution to the evaluation challenge for the Development and Technology team at Puntospoint. Below are the instructions for setting up the server and testing the implemented functionalities.

## Usage Instructions

### Setting Up the Server

To set up the server, follow these steps:

1. Clone this repository to your local machine.
2. Install project dependencies using `bundle install`
4. Configure the PostgreSQL database and ensure you have Ruby 1.9.3 and Rails 3.
5. Run `rake db:create` to create the database.
6. Run database migrations with the command:
```bash
`rake db:migrate`.
```
7. Run database migrations for test environment with the command:
```bash
`rake db:migrate RAILS_ENV=test`.
```

8. Populate the database with seed data using:
```bash
`rake db:seed`.
```
9. After running the seeds, you can use the following credentials to access the admin user:

- Email: admin@example.com
- Password: password

10. Start the Rails server with the command:
```bash
`rails server`.
```

## Environment Variables Configuration

Before running the application, please make sure to set up the following environment variables:

### Mailtrap Configuration

Create an account on Mailtrap for sending emails to administrators. Once you've created your account, ensure to associate the following details with the respective environment variables:

- `MAILTRAP_ADDRESS`: The SMTP address provided by Mailtrap.
- `MAILTRAP_PORT`: The SMTP port provided by Mailtrap (usually 2525).
- `MAILTRAP_DOMAIN`: Your Mailtrap domain.
- `MAILTRAP_USER`: Your Mailtrap account username.
- `MAILTRAP_PASSWORD`: Your Mailtrap account password.

### Database Configuration

Configure the database connection by setting the following environment variables:

- `LOCAL_DATABASE_HOST`: The local database host address (usually `localhost`).
- `LOCAL_DATABASE_USERNAME`: The local database user.
- `LOCAL_DATABASE_PASSWORD`: The local database password.

### Default Email Address

Set the default email address that will be used as the sender for emails:

- `DEFAULT_EMAIL_FROM`: The default email address (e.g., `noreply@example.com`).

You can copy the values from `.env.example` to set up your environment variables.

Remember to keep your environment variables secure and not include them in version control.

## Additional Setup for Daily Purchase Reporting

To enable the daily purchase reporting process, follow these additional steps:

1. Ensure you have Sidekiq set up in your local environment.
2. Start Sidekiq by running `bundle exec sidekiq` in your terminal.
3. Open another terminal tab and run `rails console`.
4. Inside the Rails console, run the command `DailyReportWorker.perform_async` to start the daily reporting process.

 ## Running Tests

The project includes RuboCop for code linting and RSpec for testing. You can run the tests using the following command:

```bash
rspec
```

## Entity-Relationship Diagram (ERD)

![DER](https://github.com/valentinopfarherr/ecommerce-rails-3/assets/127141076/2ecaee66-35b4-4389-8c4e-57fb94f5caf4)

You can also find the ERD in the following [issue](https://github.com/valentinopfarherr/ecommerce-rails-3/issues/1) in the repository.

## Postman Collection

[postman_collection](postman/collection.json)

The Postman collection for this project is located in the `postman` folder. You can import this JSON file into your Postman client to test the various project APIs.

You also check the online collection:

[postman](https://www.postman.com/valentinopfarherr/workspace/ruby-challenge)

## Project Swagger Doc

[swagger](https://app.swaggerhub.com/apis/VALENTINOPFARHERR/ecommerce-api/1.0.0)

## Additional Details

- The source code has been organized following best practices in Ruby on Rails development.
- Advanced model associations have been implemented to meet functional requirements.
- Special emphasis has been placed on security by implementing JWT authentication for APIs and securely storing credentials.
- Automated tests have been developed using RSpec to ensure the correct operation of APIs.
- Sidekiq has been used for the implementation of the daily purchase reporting process.
- APIs have been optimized for high performance, avoiding unnecessary SQL queries and using caches where appropriate.
- Cache mechanisms have been implemented in Statistics APIs.
- The first product purchase email has been tested under race conditions.
