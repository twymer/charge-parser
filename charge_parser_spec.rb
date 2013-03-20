#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'charge_parser'

describe ChargeParser do
  before do
    @default_feature = "TXT MESSAGING – 250"
    @default_dates = "09/29 – 10/28"
    @default_price = "4.99"
  end

  def charge_line(params = {})
    fields = {feature: @default_feature,
              dates: @default_dates,
              price: @default_price}.merge(params)

    return "$4.99 #{fields[:feature]} #{fields[:dates]} #{fields[:price]}"
  end

  it "should parse a valid line" do
    result = ChargeParser.parse(charge_line)
    result[:feature].should == @default_feature
    result[:date_range].should == @default_dates
    result[:price].should == @default_price
  end

  it "should parse only the last price" do
    result = ChargeParser.parse(charge_line(price: '6.50'))
    result[:price].should == '6.50'
  end

  it "should not break on extraneous spaces" do
    result = ChargeParser.parse(charge_line({feature: '       500 - minutes    ',
                                             dates: '  04/15 - 02/28 ',
                                             price: '  5.50  '}))
    result[:feature].should == '500 - minutes'
    result[:date_range].should == '04/15 - 02/28'
    result[:price].should == '5.50'
  end

  it "should handle very large prices" do
    result = ChargeParser.parse(charge_line(price: '12345.67'))
    result[:price].should == '12345.67'
  end

  it "should handle short form dates" do
    result = ChargeParser.parse(charge_line(dates: '7/2 - 8/3'))
    result[:date_range].should == '7/2 - 8/3'
  end

  it "should not error for invalid lines" do
    result = ChargeParser.parse(charge_line({feature: '', dates: 'banana', price: 'oops'}))
    result.should == []
  end

  it "should not parse if price field is missing" do
    result = ChargeParser.parse(charge_line(price: ''))
    result.should == []
  end

  it "should still parse even with no feature" do
    result = ChargeParser.parse(charge_line(feature: ''))
    result[:feature] == ''
    result[:date_range] == @default_dates
  end
end
