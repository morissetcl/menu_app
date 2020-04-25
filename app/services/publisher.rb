# frozen_string_literal: true

require 'bunny'

class Publisher
  RABBIMQ_URL = ENV.fetch('RABBITMQ_URL', 'amqp://localhost:5672')
  def self.publish(exchange, message = {})
    x = channel.fanout("crawler.#{exchange}")
    x.publish(message.to_json)
    connection.close
  end

  def self.channel
    @channel ||= connection.create_channel
  end

  def self.connection
    @connection ||= Bunny.new(RABBIMQ_URL).tap(&:start)
  end
end
