#!/usr/bin/env ruby
# encoding: utf-8

require 'pry'

original_input = "$4.99 TXT MESSAGING – 250 09/29 – 10/28 4.99"

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
      parsed.first[0].strip!
    end
    return parsed
  end
end
