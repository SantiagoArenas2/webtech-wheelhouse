# Wheelhouse

Wheelhouse is a small Rails application for an independent bicycle workshop. It presents the public service price list, workshop details, and the story behind the shop. This is the Lab 4 application built on the Lab 3 specification.

## Project documents

- [User stories](docs/user-stories.md)
- [Domain model](docs/domain-model.md)
- [Design decisions](docs/decisions.md)
- [Wireframes](docs/wireframes.md)

## Requirements

- Ruby 3.3.12 (Ruby 4.0.4 also works with the assignment setup)
- Rails 8.0.5.1
- Node.js 24.16.0 and npm 11.13.0
- PostgreSQL 17

On Windows, install Ruby with RubyInstaller and its MSYS2 development tools. PostgreSQL must be running locally and the current Windows user must be allowed to create databases.

## Setup

Clone the repository and run these commands from its root:

```text
bundle install
npm install
$env:PGUSER="postgres"
$env:PGPASSWORD="your-local-postgres-password"
bin/rails db:create
```

There are no migrations or tables in this lab. The application only needs the development and test databases to exist.

## Start the application

Run both the Rails server and the Sass watcher with:

```text
bin/dev
```

Then open http://localhost:3000. To start only Rails without rebuilding CSS, use `bin/rails server`.

Useful checks:

```text
bin/rails about
bin/rails routes
```
