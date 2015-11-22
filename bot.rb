require 'telegram_bot'
require 'pp'
require 'logger'

begin 
  logger = Logger.new(STDOUT, Logger::DEBUG)
  
  bot = TelegramBot.new(token: '', logger: logger)
  logger.debug "starting telegram bot"

  bot.get_updates(fail_silently: true) do |message|
    logger.info "@#{message.from.username}: #{message.text}"
    command = message.get_command_for(bot)

    message.reply do |reply|
      case command
      when /greet/i
        reply.text = "Hello, #{message.from.first_name}!"
      when /吃貨日記/i
        reply.text = "要看吃貨日記,請找耽擱,爾蚊,Wen...等人申請..請提供gmail."
      when /近期行程/i
        reply.text = "1. 2015.12.03 Abaddon(19:30~)\r\n
                       阿巴丼 大安大隊 C66、C99、C112 慶功宴 莫宰羊-大安台大店-羊肉爐/羊肉火鍋\r\n
                       2. 2015.12.03 ENL Abaddon 慶功宴\r\n"

      else
        reply.text = "#{message.from.first_name}, have no idea what #{command.inspect} means."
      end
      logger.info "sending #{reply.text.inspect} to @#{message.from.username}"
      reply.send_with(bot)
    end
 end
rescue Exceptions =>e
  logger.info "error: #{e.message}"
end 
