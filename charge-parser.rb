#!/usr/bin/env ruby
# encoding: utf-8

require 'pry'

original_input = "$4.99 TXT MESSAGING – 250 09/29 – 10/28 4.99"

matcher = /^\$\d*\.\d{2}\s*(.*)\s*(\d{2}\/\d{2}\W.\W\d{2}\/\d{2})\s*(\d*\.\d{2})/

result = original_input.scan(matcher)
puts result
