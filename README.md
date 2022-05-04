## Installation

Install vendors

`composer install`

`npm install`

Initialize `.env` and set database variables

`cp .env.example .env`

Generate key for project

`php artisan key:generate`

Start Docker containers

`docker-compose up -d`

Migrate database

`php artisan migrate:fresh --seed`
---
---2
