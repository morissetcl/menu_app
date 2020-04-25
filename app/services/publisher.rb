# frozen_string_literal: true

require 'bunny'

class Publisher
  def self.publish(exchange, message = {})
    x = channel.fanout("crawler.#{exchange}", auto_delete: true)
    x.publish(message.to_json)
  end

  def self.channel
    @channel ||= connection.create_channel
  end

  def self.connection
    @connection ||= Bunny.new(username: RABBITMQ_USERNAME,
                              password: RABBITMQ_PASSWORD,
                              vhost: RABBITMQ_VHOST)
                         .tap(&:start)
  end
end
