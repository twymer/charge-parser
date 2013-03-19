#!/usr/bin/env ruby
# encoding: utf-8

require 'rspec'
require_relative 'charge_parser'

describe ChargeParser do
  before do
    @default_text = "TXT MESSAGING – 250"
    @default_dates = "09/29 – 10/28"
    @default_price = "4.99"
  end

  def charge_line(params = {})
    fields = {text: @default_text,
              dates: @default_dates,
              price: @default_price}.merge(params)

    return "$4.99 #{fields[:text]} #{fields[:dates]} #{fields[:price]}"
  end

  it "should parse a valid line" do
    result = ChargeParser.parse(charge_line).first
    result[0].should == @default_text
    result[1].should == @default_dates
    result[2].should == @default_price
  end

  it "should parse only the last price" do
    result = ChargeParser.parse(charge_line(price: '6.50')).first
    result[2].should == '6.50'
  end

  it "should not break on extraneous spaces" do
    result = ChargeParser.parse(charge_line({text: '       500 - minutes    ',
                                             dates: '  04/15 - 02/28 ',
                                             price: '  5.50  '})).first
    result[0].should == '500 - minutes'
    result[1].should == '04/15 - 02/28'
    result[2].should == '5.50'
  end

  it "should handle very large prices" do
    result = ChargeParser.parse(charge_line(price: '12345.67')).first
    result[2].should == '12345.67'
  end

  it "should handle short form dates" do
    result = ChargeParser.parse(charge_line(dates: '7/2 - 8/3')).first
    result[1].should == '7/2 - 8/3'
  end

  it "should not error for invalid lines" do
    result = ChargeParser.parse(charge_line({text: '', dates: 'banana', price: 'oops'}))
    result.should == []
  end
end
