require 'sqlite3'

db = SQLite3::Database.new("stockbrokerage.db")
db.results_as_hash = true

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

#Add a stock rating to Database.
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
#update a stock rating
def update_rating (db,stock_ticker,rating)
   db.execute(<<-SQL
    UPDATE stocks2 
    SET recommendation_id="#{rating}" 
    Where stock_ticker="#{stock_ticker}";
    SQL
  )
 
end
# remove a stock from database
def remove_stock(db,stock_ticker)
  db.execute(<<-SQL
    DELETE FROM stocks2 
    Where stock_ticker="#{stock_ticker}";
    SQL
  )
end
# display all stock info 
def full_info(db)
  info = db.execute("SELECT stocks2.company_name,stocks2.stock_ticker,stocks2.stock_price,stocks2.stock_exchange,stocks1.recommendation  FROM stocks2 JOIN stocks1 ON stocks2.recommendation_id = stocks1.id;")
  puts ""
    info.each do |category|
      puts "
            Company Name  : #{category['company_name']} 
            Stock Ticker  : #{category['stock_ticker']}
            Stock Price   : #{category['stock_price']}
            Stock Exchange: #{category['stock_exchange']}
            Rating        : #{category['recommendation']}"
    
        end

end
  # View stock rating by stock ticker.
def stock_rating_by_ticker(db,stock_ticker)
    info =db.execute(<<-SQL
    SELECT  stocks1.recommendation 
    FROM stocks2 JOIN stocks1 
    ON stocks2.recommendation_id = stocks1.id 
    Where stock_ticker="#{stock_ticker}";
    SQL
    )
    info.each do |category|
    puts " 
          Rating : #{category['recommendation']}"
        end
end
# view stocks by certain price 
def stock_by_price(db,price)
    info =db.execute(<<-SQL
    SELECT  stocks2.stock_ticker stocks2.stock_price FROM stocks2 Where stock_price >"#{price}";
    SQL
    )
     
    info.each do |category|
    puts " 
      Stock Ticker : #{category['stock_ticker']}
      Stock Price  : #{category['stock_price']}"
        end

end
# method to display less info about each stock.
def less_info(db)
    info = db.execute("SELECT stocks2.stock_ticker,stocks1.recommendation FROM stocks2 JOIN stocks1 ON stocks2.recommendation_id = stocks1.id;")
   
     info.each do |category|
      puts " 
          Stock Ticker : #{category['stock_ticker']}
          Rating       : #{category['recommendation']}"
        end
end


#driver code
# if you download my database file please comment out line 130 to 132.
#otherwise comment out line 130 to 132 after running the code once.
#these 3 categories are mandatory for a firm to rate a stock!
stocks1_category(db,"BUY")
stocks1_category(db,"HOLD")
stocks1_category(db,"SELL")
# stocks2_category(db,"Apple Inc.","AAPL",112.71,"NASDAQ",1)

puts "Please enter your name to start using software:"
name=gets.chomp
introduction(name)
loop do

puts""
puts"What would you like to do.Select a number from below:\n
1 - Add a stock rating to Database.
2 - Update a stock rating in Database.
3 - Remove a stock from Database.
4 - View stock rating by stock ticker.
5 - View stocks by certain price.
6 - View all stock in database with full information.
7 - EXIT"
input = gets.chomp.to_i
break if input == 7 

if input == 1
  puts "What is company's name?"
  company = gets.chomp
  puts "What is stock's ticker symbol on exchange?"
  ticker = gets.chomp.upcase
  puts "What is stock's price at the moment?"
  price = gets.chomp.to_i
  puts "What stock exchange the stock trades on like 'NYSE' 'NASDAQ' etc."
  exchange=gets.chomp.upcase
  puts "What rating would you recommend for this stock?\n
  type 1 for BUY
  type 2 for HOLD
  type 3 for SELL "
  
  recomm=gets.chomp.to_i
 
  stocks2_category(db,company,ticker,price,exchange,recomm)

elsif input == 2
  # 2 - Update a stock rating in Database.
  less_info(db)
  puts "Which stock's rating would you like to Update?"
  
  puts "Enter Stock Ticker:"
  stock_ticker = gets.chomp.upcase.to_s
  p stock_ticker
  puts "What is your updated rating 
  type 1 for BUY
  type 2 for HOLD
  type 3 for SELL"
  rating = gets.chomp.to_i
  p rating 

  p update_rating(db,stock_ticker,rating)

elsif input == 3
  puts "Which stock you want to remove from database?"
   less_info(db)
  puts "Enter Stock Ticker To Remove:"
  stock_ticker=gets.chomp.upcase

  remove_stock(db,stock_ticker)

elsif input == 4
    puts "Which stock's Rating you need to check?"

    less_info(db)
    puts "Enter Stock Ticker:"

    stock_ticker=gets.chomp.upcase

    stock_rating_by_ticker(db,stock_ticker)
    
elsif input == 5
      # View stocks by certain price.
      puts "Enter price to see all stocks above that price."
      price=gets.chomp.to_i
      stock_by_price(db,price)

    

elsif input == 6
 full_info(db)

else 
  puts "==========================================================="
  puts "Hey #{name}!!!!!Don't sleep on the job!!! PAY ATTENTION!!!!
                Wake up and pick a number from 1 to 7 :) "
  puts "==========================================================="
end
end
puts "==================================================================="
puts "Now go home,spend some time with family and catch up on some sleep.
======================Have a wonderful day=========================="
puts "==================================================================="

# program can use a lot more improvement like create more flexibility with price and update more things like 
# price,stock exchange  or other categories and handle user input but I'm short on time.sorry :(