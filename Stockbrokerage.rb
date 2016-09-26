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
def stocks2_category(db,company,ticker,price,exchange,recomm)
  db.execute("INSERT INTO stocks2 (company_name,
    stock_ticker,
    stock_price,
    stock_exchange,
    recommendation_id) VALUES (?,?,?,?,?)",[company,ticker,price,exchange,recomm])
end
def introduction(name)
 @name = name
puts "          Hey #{@name}, Nice to meet you :) \n
********************************************************
* Congratulations on your new job as Stock Analyst for *\n 
*               AMRIN BROKERAGE FIRM                   *                 
* We are paying you a hefty salary because millions of *\n
* people depend on your stock recommendations.So please*\n
* make sure you give your 100 PERCENT on the job.      *\n
********************************************************"
end
def full_info(db)
  db.execute("SELECT stocks2.company_name,stocks2.stock_ticker,stocks2.stock_price,stocks2.recommendation_id, stocks1.recommendation FROM stocks2 JOIN stocks1 ON stocks2.recommendation_id = stocks1.id;")
  puts ""
end


#driver code
#these 3 are categories are mandatory for a firm to rate a stock!
# stocks1_category(db,"BUY")
# stocks1_category(db,"HOLD")
# stocks1_category(db,"SELL")
# stocks2_category(db,"Apple Inc.","AAPL",112.71,"NASDAQ",1)

puts "Please enter your name to start using software:"
name=gets.chomp
introduction(name)

puts""
puts"What would you like to do first.Select number from below:\n
1 - Add a stock rating to Database.
2 - Update a stock rating in Database.
3 - Remove a stock from Database.
4 - View stock rating by stock ticker.
5 - View stocks by certain price.
6 - View all stock in database with full information."
input = gets.chomp

if input == 1
elsif input == 6
  full_info
else 
  puts "#{name}!!!!!Don't sleep on the job!!! PAY ATTENTION!!!!"
end
