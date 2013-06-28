require 'rubygems'
require 'data_mapper'



class Clicks
  include DataMapper::Resource

  property :id,         Serial
  property :click_id, Integer
  property :user_id, Integer
  property :click_payout, Integer
  # property :currency, string
  # property :click_payout_currency, decimal
end

#select * from clicks where currency not is null and click_payout_currency not is null and click_payout is null




DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://prosper202:L7mcsTe@localhost/prosper202')
