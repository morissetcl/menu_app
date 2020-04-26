# frozen_string_literal: true

require 'bunny'

class Publisher
  def self.publish(exchange, message = {})
    x = channel.fanout("crawler.#{exchange}")
    x.publish(message.to_json)
  end

  def self.channel
    @channel ||= connection.create_channel
  end

  def self.connection
    @connection ||= Bunny.new.tap(&:start)
  end
end
