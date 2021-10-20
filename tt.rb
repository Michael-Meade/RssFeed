require 'rss'
require 'open-uri'
require 'pp'
require 'sinatra'
class RSSFeed
  def urls
    ["http://feeds.feedburner.com/TheHackersNews?format=xml", "https://www.bleepingcomputer.com/feed/", "https://krebsonsecurity.com/feed/", "https://therecord.media/feed/"]
  end
  def rss()
    out = []
    urls.each do |u|
      URI.open(u) do |rss|
        feed = RSS::Parser.parse(rss)
        feed.items.each do |item|
            out << [item.link, item.title]
        end
      end
    end
  return out
  end
  def magic
    thn = [] 
    bc  = []
    tr  = []
    krebs = []
    rss.each { |o| bc    << [ o[0], o[1]] if o[0].include?("bleepingcomputer")}
    rss.each { |o| thn   << [ o[0], o[1]] if o[0].include?("feedproxy")}
    rss.each { |o| tr    << [ o[0], o[1]] if o[0].include?("therecord")}
    rss.each { |o| krebs << [ o[0], o[1]] if o[0].include?("krebsonsecurity")}
    return [ thn, bc, tr, krebs ]
  end
end
class HTMLTemplate
  def table_row(m)
    thn =  m[0]
    bc  =  m[1]
    t   =  m[2]
    out = ""
    for i in 0..9
      k = "<tr><td><center><a href="+thn[i][0]+">"+thn[i][1]+"</a></center></td>
           <td><center><a href="+t[i][0]+">"+t[i][1]+"</a></center></td>
           <td><center><a href="+bc[i][0]+">"+bc[i][1]+"</a></center></td>"
      out+= k
      i+=1
    end
  return out
  end
end

get '/' do
  erb :index
end