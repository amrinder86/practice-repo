require 'sqlite3'
db = SQLite3::Database.new("stockbrokerage.db")

create_table_stocks1 = <<-SQL
  CREATE TABLE IF NOT EXISTS stocks1(
    id INTEGER PRIMARY KEY,
    recommendation VARCHAR(255)
  )
SQL

db.execute(create_table_stocks1)

create_table_stocks2 =  <<-SQL
  CREATE TABLE IF NOT EXISTS stocks2(
    id INTEGER PRIMARY KEY,
    company_name VARCHAR(255),
    stock_ticker VARCHAR(255),
    stock_price INT,
    stock_exchange VARCHAR(255),
    recommendation_id INT,
    FOREIGN KEY (recommendation_id) REFERENCES stocks1(id));
  )
SQL

db.execute(create_table_stocks2)

def stocks1_category(db,category)
  db.execute("INSERT INTO stocks1 (recommendation) VALUES (?)",[category])
end
def stocks2_category(db,category)
  db.execute("INSERT INTO stocks1 (recommendation) VALUES (?)",[category])
end

#driver code
#these 3 are categories are mandatory for a firm to rate a stock!
stocks1_category(db,"BUY")
stocks1_category(db,"HOLD")
stocks1_category(db,"SELL")
