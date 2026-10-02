# Meus Quadrinhos

![Preview](preview.png)

An app to catalog comics, build a personal collection, and track what you have read.

## 🛠️ Tech Stack

![Ruby](https://img.shields.io/badge/Ruby-3.3-CC342D?style=for-the-badge&logo=ruby&logoColor=white)
![Rails](https://img.shields.io/badge/Rails-7.1-CC0000?style=for-the-badge&logo=rubyonrails&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![TailwindCSS](https://img.shields.io/badge/Tailwind_CSS-4-06B6D4?style=for-the-badge&logo=tailwindcss&logoColor=white)
![Turbo](https://img.shields.io/badge/Turbo-Hotwire-5CD8A5?style=for-the-badge&logo=hotwire&logoColor=white)
![Stimulus](https://img.shields.io/badge/Stimulus-Hotwire-77E8B9?style=for-the-badge&logo=stimulus&logoColor=black)
![Chart.js](https://img.shields.io/badge/Chart.js-Graphs-FF6384?style=for-the-badge&logo=chartdotjs&logoColor=white)

## ✨ Features

- Comic records with cover, issue, year, pages, and stories
- Catalog of collections, authors, characters, publishers, bindings, paper types, and comic types
- Personal collection per user
- Reading log
- Dashboard with totals, reading streak, and charts
- User authentication
- Admin area
- Catalog export as JSON

## 🚀 Getting Started

### 1. Install system dependencies

- Ruby 3.3.0
- PostgreSQL
- Node.js and Yarn
- ImageMagick

This might help you:

- [Ruby setup](https://phzsantos.github.io/posts/ruby-setup/)
- [How to install PostgreSQL on Linux Mint](https://phzsantos.github.io/posts/how-to-install-postgresql-linux-mint/)
- [How to install Yarn on Linux Mint](https://phzsantos.github.io/posts/how-to-install-yarn-linux-mint/)

### 2. Install gems

```bash
bundle install
```

### 3. Install front-end packages

```bash
yarn install
```

### 4. Create and seed the database

```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

The seed creates a local admin user:

- Email: `admin@admin.com`
- Password: `123456`

### 5. Run the application

```bash
bin/dev
```

The app runs at [http://localhost:3000](http://localhost:3000).

## 📄 License

This project is licensed under the **GNU Affero General Public License v3.0**.
