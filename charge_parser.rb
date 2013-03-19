#!/usr/bin/env ruby
# encoding: utf-8

require 'pry'

class ChargeParser
  price_matcher = /\d*\.\d{2}/
  date_matcher = /\d{1,2}\/\d{1,2}/

  @matcher = /
               ^\$#{price_matcher}                    # ignore first price
               (.*)\s+                                # everything between price and dates
               (#{date_matcher}\W.\W#{date_matcher})  # date range
               \s*
               (#{price_matcher})                     # price
             /x

  def self.parse(input)
    parsed = input.scan(@matcher)
    if parsed.any?
      return { feature: parsed.first[0].strip,
               date_range: parsed.first[1],
               price: parsed.first[2] }
    else
      return []
    end
  end
end
