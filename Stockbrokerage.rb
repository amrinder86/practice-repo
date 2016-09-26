require 'sqlite3'
db = SQLite3::Database.new("stockbrokerage.db")

create_table_stocks1 = <<-SQL
  CREATE TABLE IF NOT EXISTS stocks1(
    id INTEGER PRIMARY KEY,
    recommendation VARCHAR(255)
  )
SQL

create_table_stocks2 =  <<-SQL
  CREATE TABLE IF NOT EXISTS stocks2(
    
  )
SQL
