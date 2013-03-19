#!/usr/bin/env ruby
# encoding: utf-8

require 'pry'

original_input = "$4.99 TXT MESSAGING – 250 09/29 – 10/28 4.99"

price_matcher = /\d*\.\d{2}/
date_matcher = /\d{2}\/\d{2}/

matcher = /
            ^\$#{price_matcher}                    # ignore first price
            \s*(.*)\s*                             # everything between price and dates
            (#{date_matcher}\W.\W#{date_matcher})  # date range
            \s*
            (#{price_matcher})                     # price
          /x

result = original_input.scan(matcher)
puts result
