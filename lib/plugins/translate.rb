require 'cinch'
require 'open-uri'
require "json"
require 'cgi'

class Translate < CinchPlugin
  include Cinch::Plugin 
  set :help, "!translate <src> into <target> <wrold>"


  ####Work in progress can't get json to parse
  #match /translate (.*?) into .*?) (.*?)/, method: :translate

  def initialize(args)
    super
    @languages = {"af" => "Afrikaans", "sq" => "Albanian",
    "ar"=>"Arabic","be"=>"Belarusian","bg"=>"Bulgarian","ca"=>"Catalan","zh-CN"=>"Simplified Chinese",
    "zh-TW"=>"Traditional Chinese","hr"=>"Croatian","cs"=>"Czech","da"=>"Danish","nl"=>"Dutch","en"=>"English",
    "et"=>"Estonian","tl"=>"Filipino","fi"=>"Finnish","fr"=>"French","gl"=>"Galician","de"=>"German","el"=>"Greek",
    "iw"=>"Hebrew","hi"=>"Hindi","hu"=>"Hungarian","is"=>"Icelandic","id"=>"Indonesian","ga"=>"Irish","it"=>"Italian",
    "ja"=>"Japanese","ko"=>"Korean","lv"=>"Latvian","lt"=>"Lithuanian","mk"=>"Macedonian","ms"=>"Malay","mt"=>"Maltese",
    "no"=>"Norwegian","fa"=>"Persian","pl"=>"Polish","pt"=>"Portuguese","ro"=>"Romanian","ru"=>"Russian","sr"=>"Serbian",
    "sk"=>"Slovak","sl"=>"Slovenian","es"=>"Spanish","sw"=>"Swahili","sv"=>"Swedish","th"=>"Thai","tr"=>"Turkish",
    "uk"=>"Ukranian","vi"=>"Vietnamese","cy"=>"Welsh","yi"=>"Yiddish"}
  end

  def getLangCode(language)
    @languages.each do |code, lang|
      if lang.downcase == language.downcase
        return code
      end
    end
    return false
  end

  def lookup(csrc,cdst,phrase)
    begin
      results = JSON.parse(open("http://translate.google.com/translate_a/t?client=t&hl=en&multires=1&sc=&sl=#{csrc}&ssel=0&tl=#{cdst}&tsel=0&uptl=en&text=#{phrase}").read)
    rescue
      puts results.inspect
    end
  end

  def translate(m, src, dst,phrase)
    csrc = getLangCode(src)
    cdst = getLangCode(dst)

    if csrc == false
      m.reply("Cannot find src language of #{src}")
    elsif cdst == false
       m.reply("Cannot find dst language of #{dst}")
    else
     lookup(csrc,cdst,phrase)
   end
 end
end