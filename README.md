# Wheelhouse

Wheelhouse is a Rails 8 application for an independent bicycle workshop. It manages customers, bikes, repairs and services, including repair intake photos and rich-text diagnoses.

## Project documents

- [User stories](docs/user-stories.md)
- [Domain model](docs/domain-model.md)
- [Design decisions](docs/decisions.md)
- [Wireframes](docs/wireframes.md)

## Prerequisites

- Ruby 3.3.12 with RubyInstaller and its MSYS2 development tools
- Rails 8.0.5.1 (installed by Bundler)
- Node.js 24.16.0 and npm 11.13.0
- PostgreSQL 17, running locally on port 5433. The role is selected by
  `PGUSER`/`PGPASSWORD` and defaults to `postgres`.
- libvips, used to generate photo thumbnails. In the RubyInstaller MSYS2
  UCRT64 shell, install it with:

  ```sh
  pacman -S mingw-w64-ucrt-x86_64-libvips
  ```

See the [libvips installation guide](https://www.libvips.org/install.html) for
other operating systems.

## Setup on Windows

Clone the repository, open PowerShell in the project folder, and run:

```powershell
bundle install
npm install
$env:PGUSER = "postgres"
$env:PGPASSWORD = "your-local-postgres-password"
ruby .\bin\rails db:prepare
ruby .\bin\rails db:seed
npm run build:css
```

`db:prepare` creates the development database and runs all migrations,
including Active Storage and Action Text. `db:seed` loads example repairs,
photos and formatted diagnoses. The seeds are safe to run again.

## Run the application

Start Rails from PowerShell:

```powershell
ruby .\bin\rails server
```

Then open http://localhost:3000. Rebuild the stylesheet after changing
`app/assets/stylesheets/application.bootstrap.scss` with `npm run build:css`.

Useful checks:

```powershell
ruby .\bin\rails about
ruby .\bin\rails routes
ruby .\bin\rails db:migrate:status
```

Development uploads are stored in the ignored `storage/` directory. The sample
seed images are committed separately in `db/seeds/photos/` and are attributed
below.

### Seed image credits

- [Bicycle workshop Ruyigi](https://commons.wikimedia.org/wiki/File:Bicycle_workshop_Ruyigi.JPG), Andreas31, CC BY-SA 3.0.
- [Bicycle workshop in the Museu Isern de la Moto](https://commons.wikimedia.org/wiki/File:Bicycle_workshop_in_the_Museu_Isern_de_la_Moto.jpg), Peprovira, CC BY-SA 4.0.
- [Bike workshop - bicycle repair shop](https://commons.wikimedia.org/wiki/File:Bike_workshop_-_bicycle_repair_shop.jpg), Alextredz, CC BY-SA 4.0.
- [Edinburgh Bicycle Cooperative, Woodland Lane](https://commons.wikimedia.org/wiki/File:Edinburgh_Bicycle_Cooperative,_Woodland_Lane,_Chapel_Allerton_(16th_November_2013).JPG), Mtaylor848, CC BY-SA 3.0.
