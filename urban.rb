require 'open-uri'
require 'nokogiri'
require 'erb'
require 'colorize'

class String
  def wrap(length = 80, character = $/)
    words = self.split ' '
    str = words.shift
    words.each do |word|
      connection = (str.size - str.rindex("\n").to_i + word.size > length) ? "\n" : " "
      str += connection + word
    end
    str
  end
end

def random
  url = URI.parse("http://www.urbandictionary.com/random.php")
  result = Nokogiri::HTML(open(url))
  print_definition result
end

def print_definition(result)
  puts result.xpath("//div[@class='word']/span").first.inner_text.strip!.bold.light_blue + "\n\n"
  puts result.xpath("//div[@class='definition']").first.inner_text.wrap + "\n"
end

def define(word)
  url = URI.parse("http://www.urbandictionary.com/define.php?term=#{ERB::Util.url_encode(word)}")
  result = Nokogiri::HTML(open(url))
  print_definition result
end

if ARGV.size < 1
  random
else
  define ARGV.join(' ') 
end
