# Meus Quadrinhos

![Demo](docs/assets/gifs/demo.gif)

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

## 📈 Statistics

### Latest reads

![Latest reads](docs/assets/statistics/_latest_reads.png)

- The last 6 comics read
- Cover
- Title
- Read date

### General statistics

![General statistics](docs/assets/statistics/_general_statistics.png)

- Comics read
- Stories read
- Pages read
- Comics read this month
- Current reading streak

### Collection statistics

![Collection statistics](docs/assets/statistics/_collection_statistics.png)

- Total comics in the collection
- Total unread comics
- Total pages
- Total stories

### Reading records

![Reading records](docs/assets/statistics/_reading_records.png)

- Month with the most comics read
- Month with the most stories read
- Month with the most pages read
- Longest reading streak

## 📊 Charts

### Reading activity

Contribution graph showing how many comics you read each day over the past year.

![Reading activity](docs/assets/charts/_reading_activity.png)

### Monthly metrics

| Day-by-day comparison | Comics read per month |
| :---: | :---: |
| ![Comics read by day comparison](docs/assets/charts/_chart_comics_read_by_day_comparison.png) | ![Comics read by month](docs/assets/charts/_chart_comics_read_by_month.png) |

| Pages read per month | Stories read per month |
| :---: | :---: |
| ![Pages read by month](docs/assets/charts/_chart_pages_read_by_month.png) | ![Stories read by month](docs/assets/charts/_chart_stories_read_by_month.png) |

### Annual metrics

| Comics read per year | Pages read per year |
| :---: | :---: |
| ![Comics read by year](docs/assets/charts/_chart_comics_read_by_year.png) | ![Pages read by year](docs/assets/charts/_chart_pages_read_by_year.png) |

### General statistics

| Most-read characters | Most-read authors |
| :---: | :---: |
| ![Comics read by character](docs/assets/charts/_chart_comics_read_by_character.png) | ![Comics read by author](docs/assets/charts/_chart_comics_read_by_author.png) |

| Comics read by paper type | Comics read by book binding |
| :---: | :---: |
| ![Comics read by paper type](docs/assets/charts/_chart_comics_read_by_paper_type.png) | ![Comics read by book binding](docs/assets/charts/_chart_comics_read_by_book_binding.png) |

| Comics read by publisher | Comics read by publication type |
| :---: | :---: |
| ![Comics read by publisher](docs/assets/charts/_chart_comics_read_by_publisher.png) | ![Comics read by publication type](docs/assets/charts/_chart_comics_read_by_publication_type.png) |

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
