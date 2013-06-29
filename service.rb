require 'rubygems'
require 'data_mapper'
require 'money'
require 'money/bank/google_currency'
require 'json'



class Clicks
  include DataMapper::Resource
  storage_names[:default] = "202_clicks"

  property :click_id, Serial
  property :user_id, Integer
  property :click_payout, Integer
  property :currency, String
  property :click_payout_currency, Integer

  def self.to_convert
    all(:click_payout => 0, :currency.not => nil, :click_payout_currency.not => nil )
  end
end


class CurrencyConverter
  def convert currency, money
    if currency == 'EUR'
      money
    else
      ask_google_to_convert currency, money
    end
  end

  def ask_google_to_convert currency, money
    MultiJson.engine = :json_gem # or :yajl
    Money.default_bank = Money::Bank::GoogleCurrency.new

    # create a new money object, and use the standard #exchange_to method
    n = money.to_money(currency.to_sym)
    n.exchange_to(:EUR)
  end
end


DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://prosper202:L7mcsTe@localhost/prosper202')

#puts "To Convert: #{Clicks.to_convert.size}"

Clicks.to_convert.each do |click|
  converted_payout = CurrencyConverter.new.convert(click.currency, click.click_payout_currency)
  click.click_payout = converted_payout.to_f
  click.save
  puts "converted id #{click.click_id}: #{converted_payout}, #{click.click_payout}, currency: #{click.currency}"
end
