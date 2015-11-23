require 'telegram_bot'
require 'pp'
require 'logger'

class EatBotWorker
  include Sidekiq::Worker
  def perform()
    begin 
      logger = Logger.new(STDOUT, Logger::DEBUG)
      bot = TelegramBot.new(token:  SystemSettings.tg["token"], logger: logger)
      logger.debug "starting telegram bot"
      
      bot.get_updates(fail_silently: true) do |message|
        logger.info "@#{message.from.username}: #{message.text}"
        command = message.get_command_for(bot)
        
        message.reply do |reply|
          case command
          when /greet/i,/hi/i,/hello/i,/安安/i
            reply.text = ["Hello, #{message.from.first_name}",
                          "安安, #{message.from.first_name} 您今天吃了嗎?"
                          ].sample
          when "/calendar",/吃貨日記/i
            reply.text = "要看吃貨日記,請找耽擱,爾蚊,Wen...等人申請..請提供gmail."
          when "/schedule",/近期行程/i
            reply.text = "1. 2015.12.03 Abaddon(19:30~)
                      阿巴丼 大安大隊 C66、C99、C112 慶功宴 莫宰羊-大安台大店-羊肉爐/羊肉火鍋\n
                      2. 2015.12.05 ENL Abaddon 綠軍慶功宴(11:30~
                      桶海
                      "
          when "/map", /吃貨地圖/i
            reply.text = "#{message.from.first_name}, 拿去您要的 吃貨地圖  https://goo.gl/DZ38El"      
          when /add/i, /suggest/i
            File.open( SystemSettings.tg["suggest_file"] ,'a') do  | f |
              f << "#{message.from.first_name}=>\r\n #{command.inspect}\r\n "
            end
            reply.text ="#{message.from.first_name}, 謝謝, 已紀錄您的建議 #{command.inspect}"
          when "/help",/你會什/i
            reply.text = ["我只會吃..... ",
                          "你說呢?","先說說你會什吧?!",
                          "功能建置中..... Please wait....先吃個黃瓜吧!! o.o/"
                          ].sample 
          else
            reply.text = "#{message.from.first_name}, #{command.inspect} 是甚麼? 可以吃嗎?"
          end
          logger.info "sending #{reply.text.inspect} to @#{message.from.username}"
          reply.send_with(bot)
        end
      end
    rescue Exceptions =>e
      logger.info "error: #{e.message}"
    end 
  end
end
