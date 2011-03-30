#!/usr/bin/env ruby

# Based on: https://gist.github.com/207857

require "benchmark"
require "rubygems"

$: << File.expand_path("../../lib", __FILE__)
require "artisan"
require "nokogiri"
require "haml"
require "erubis"
require "tagz"
require "builder"
require "erector"

module Markaby
  class Fragment < ::Builder::BlankSlate
    def to_s; end
    def inspect; end
    def ==; end
  end
end
require "markaby"

include Erector::Mixin

max = (ARGV.shift || 10_000).to_i

def do_nothing url
  url
end

class String
  def smush!
    gsub!(/^ */, '').gsub!(/\n/, '')
  end
end

@obj = Object.new

eruby = <<-EOF
<html>
  <head>
    <title>happy title</title>
  </head>
  <body>
    <h1>happy heading</h1>
    <% 10.times do %>
    <a href="<%= url %>">a link</a>
    <% end %>
  </body>
</html>
EOF
eruby.smush!
Erubis::Eruby.new(eruby).def_method(@obj, "erubis(url)")

def do_erubis url
  @obj.erubis(url)
end

haml = <<-EOF
%html
  %head
    %title happy title
  %body
    %h1 happy heading
    - 10.times do
      %a{:href => url} a link
EOF
Haml::Engine.new(haml, :ugly => true).def_method(@obj, :haml, :url)

def do_haml url
  @obj.haml(:url => url)
end

def do_tagz url
  Tagz {
    html_ {
      head_ {
        title_ "happy title"
      }
      body_ {
        h1_ "happy heading"
        10.times do
          a_ "a link", :href => url
        end
      }
    }
  }
end

class Happy < Erector::Widget
  def content
    html {
      head {
        title "happy title"
      }
      body {
        h1 "happy heading"
        10.times do
          a "a link", :href => @url
        end
      }
    }
  end
end

def do_erector url
  Happy.new(:url => url).to_html
end

def do_erector_mixin url
  erector(:locals => {:url => url}) {
    html {
      head {
        title "happy title"
      }
      body {
        h1 "happy heading"
        10.times do
          a "a link", :href => url
        end
      }
    }
  }
end

def do_builder url
  Builder::XmlMarkup.new.html { |xm|
    xm.head {
      xm.title "happy title"
    }
    xm.body {
      xm.h1 "happy heading"
      10.times do
        xm.a "a link", :href => url
      end
    }
  }
end

Markaby::Builder.set :output_meta_tag, false
def do_markaby url
  mab = Markaby::Builder.new

  mab.html {
    head {
      title "happy title"
    }
    body {
      h1 "happy heading"
      10.times do
        a "a link", :href => url
      end
    }
  }.to_s
end

def do_nokogiri url
  html = Nokogiri do
    html do
      head do
        title "happy title"
      end

      body do
        h1 "happy heading"
        10.times do
          a "a link", :href => url
        end
      end
    end
  end

  html.to_s
end

class Artis
  include Artisan::HTML

  def render(url)
    html do
      head do
        title { "happy title" }
      end

      body do
        h1 { "happy heading" }
        10.times do
          a(:href => url) { "a link" }
        end
        nil
      end
    end
  end
end

def do_artisan url
  Artis.new.render(url)
end


engines = %w{artisan tagz erector erector_mixin nokogiri builder haml erubis markaby}

previous = nil
previous_engine = nil
engines.each do |engine|
  html = send "do_#{engine}", "http://example.com"

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
        html = send "do_#{engine}", url
        raise "bad html from #{engine}: #{html}" unless (html.match(url))
      end
    end
  end
end