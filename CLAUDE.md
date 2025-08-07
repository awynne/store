# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
This is a Rails 8.0.2 e-commerce application featuring product management with categories for shirts, socks, jackets, and shoes.

## Development Commands

### Server & Development
- `bin/rails server` - Start the Rails development server (default port 3000)
- `bin/rails server -p 4000` - Start server on custom port
- `bin/rails console` - Open Rails console for interactive debugging
- `bin/rails generate` - Generate Rails components (controllers, models, migrations, etc.)
- `bin/rails runner "Product.count"` - Run Ruby code in Rails environment

### Database Operations
- `bin/rails db:setup` - Create database, run migrations, and seed data
- `bin/rails db:migrate` - Run pending migrations
- `bin/rails db:seed` - Load seed data from db/seeds.rb
- `bin/rails db:reset` - Drop, recreate, migrate, and seed database
- `bin/rails db:rollback` - Rollback the last migration

### Testing & Quality
- `bin/rails test` - Run the full test suite
- `bin/rails test:system` - Run system tests
- `bin/rails test test/models/product_test.rb` - Run specific test file
- `bin/rubocop` - Run Ruby linting (Omakase styling)
- `bin/brakeman` - Run security vulnerability scanner

### Asset & Deployment
- `bin/rails assets:precompile` - Precompile assets for production
- `bin/rails routes` - Show all application routes

## Development Standards

### Pre-commit Requirements
- **ALWAYS run linting before checkins**: Execute `bin/rubocop` and fix all issues
- **Target 90-100% test coverage**: Ensure comprehensive test coverage for all new code
- Run `bin/rails test` to verify all tests pass before committing
- Do not commit to main/master branches.  Use feature branching and PRs.
- **Run all tests locally before committing**

## Application Architecture

This is a Rails 8 e-commerce store application focused on product catalog functionality.

### Core Models
- **Product** (`app/models/product.rb`): Central model with name, price, category, and description
  - Categories: shirts, socks, jackets, shoes (defined in `Product::CATEGORIES`)
  - Validations: name/price presence, price > 0, category inclusion
  - Scopes: `by_category` for filtering
  - Methods: `formatted_price` for currency display

### Controllers & Routes
- **ProductsController** (`app/controllers/products_controller.rb`): Handles product listing and detail views
  - `index`: Lists products with optional category filtering
  - `show`: Displays individual product details
- Routes: RESTful products resource with root pointing to products#index

### Views
- **Products Index** (`app/views/products/index.html.erb`)
  - Category filter buttons
  - Product cards with name, category, price, description
  - Responsive styling with inline CSS
  
- **Products Show** (`app/views/products/show.html.erb`)
  - Detailed product information
  - Navigation back to index and category filter

### Database Schema
```ruby
create_table "products" do |t|
  t.string "name"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.string "category"
  t.decimal "price", precision: 8, scale: 2
  t.text "description"
end
```

### Frontend Stack
- **Hotwire**: Turbo + Stimulus for SPA-like experience without complex JavaScript
- **Importmap**: Modern ES6 imports without bundling
- **Propshaft**: Asset pipeline for CSS/JS
- Views use ERB templates with inline styling (no external CSS framework)

### Modern Rails 8 Features
- **Solid Queue**: Database-backed job processing
- **Solid Cache**: Database-backed caching
- **Solid Cable**: Database-backed Action Cable
- Docker deployment ready with Kamal
- Thruster for HTTP acceleration

### Testing Setup
- Uses Rails' built-in test framework (not RSpec)
- Parallel test execution enabled
- Fixtures in `test/fixtures/`
- System tests with Capybara + Selenium
- **Current test coverage**: 24 tests, 80 assertions, comprehensive coverage of all models and controllers
- Controller testing support via `rails-controller-testing` gem

## Sample Data
The `db/seeds.rb` file contains 12 sample products:
- 3 shirts (t-shirt, denim shirt, polo)
- 3 socks (cotton crew, wool hiking, athletic)
- 3 jackets (leather bomber, rain jacket, fleece hoodie)  
- 3 shoes (canvas sneakers, dress shoes, running shoes)

## Deployment
- Dockerized with Kamal deployment configuration
- GitHub Actions CI/CD pipeline included
- Security scanning with Brakeman
- Code quality checks with RuboCop

## Development Notes
- Fixed nil price formatting issue in `Product#formatted_price`
- Added proper decimal precision for price field (8,2)
- Implemented category-based filtering with clean URLs
- Enhanced UI with responsive product cards and navigation

## Cross-Platform Development
- **Multi-platform Gemfile.lock**: Supports macOS (ARM64), Linux (multiple variants), Windows (x86_64/x64), and JRuby
- **Supported platforms**: 
  - macOS: `arm64-darwin-24`
  - Linux: `aarch64-linux`, `aarch64-linux-gnu`, `aarch64-linux-musl`, `arm-linux-gnu`, `arm-linux-musl`, `x86_64-linux`, `x86_64-linux-gnu`, `x86_64-linux-musl`
  - Windows: `x64-mingw32`, `x86_64-mingw32`
  - JRuby: `java`
- **Bundle install**: Works across all platforms without platform-specific issues

## Development Workflow

### Feature Branch Development
- **NO direct commits to main**: Always use feature branches and pull requests
- **Branch naming**: Use `feature/description`, `bugfix/description`, or `hotfix/description`
- **Pull Request process**: Create PR for code review before merging to main
- **Feature branch naming convention**: Name feature branches based on the github project issue number plus essential parts of the issue name

### Example Workflow
```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes and commit
git add .
git commit -m "Add new feature"

# Push to remote and create PR
git push -u origin feature/new-feature
gh pr create --title "Add new feature" --body "Description of changes"
```

## GitHub Repository
https://github.com/awynne/webstore

## Development Guidance
- Any issue in the Backlog is ready to pull and work on
- Only backlog items should be considered ready to work on.  Don't take an issue that is in "no status"

## Issue Management Workflow
- The Github project for this repo is WebStore
- Modify issue statuses as issues get moved through the workflow. 
- When creating a new issue, add it to the Backlog status. 
- The project owner then reviews issues and moves the ones to work on to the Ready status.  
- You can pick the next item in the ready column and move it to "In Progress". 
- make comments in the issue as significant changes are made. 
- test, commit, and push to remote, 
- then create a PR with mention to @awynne and move issue to Review
- add relevant commits and PR links to the issue comments. 
- Once a PR has been merged, its issue can be moved to done, and the feature branch deleted.
