# National Professional Qualification (NPQ)

## ⚡️ System Dependencies

This project requries [Ruby](https://www.ruby-lang.org/en/) 2, and [PostgreSQL](https://www.postgresql.org/) to run. 

_At inception of project the latest stable version of Ruby is [2.7.1](https://www.ruby-lang.org/en/news/2020/10/02/ruby-2-7-2-released/)_

## 🎲 Installation
[Bundler](https://bundler.io/) is used to manage project dependencies, ensure you have this installed first. 

```
bundle install
bundle rails db:setup
```

## 🎯 Usage

Start application server

```
bundle exec rails server
```

The application server will be available by default on `http://localhost:3000`

## 🤖 Testing

```
bundle exec rspec
```

## 🚨 Linting
This project assumes you have [`standardrb`](https://github.com/testdouble/standard) installed globally.

```
standardrb .
```

## 🎓 License

[The MIT Licence](LICENCE)
