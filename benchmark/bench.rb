#!/usr/bin/env ruby

require "benchmark"
require "rubygems"

max = 20_000

class String
  def smush!
    gsub!(/^ */, '').gsub!(/\n/, '')
  end
end

engines = %w{crafty tagz erector nokogiri builder haml erubis markaby}

engines.each do |engine|
  require File.expand_path(engine, File.dirname(__FILE__))
end

previous = nil
previous_engine = nil
engines.each do |engine|
  html = send "#{engine}_simple", "http://example.com/example/page.html"

  # strip whitespace from engines I don't know how to disable it on
  html.smush! if engine == "nokogiri" || engine == "haml"
  html.gsub!(/'/, '"') if engine == "haml"

  if previous && previous != html
    puts previous_engine
    p previous
    puts engine
    p html
    raise "#{previous_engine} vs. #{engine}"
  end
  previous = html
  previous_engine = engine
end

puts "# of iterations = #{max}"
Benchmark::bm(20) do |x|
  engines.each do |engine|
    x.report(engine) do
      max.times do |i|
        url = "http://example.com/#{i}"
        html = send "#{engine}_simple", url
        raise "bad html from #{engine}: #{html}" unless (html.match(url))
      end
    end
  end
end
