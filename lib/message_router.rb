require_relative './message_processor'

module Robotito
  class MessageRouter

    def message_processors
      @message_processors ||= {}
    end

    def dispatch(message, &block)
      processor = message_processors_for(message.from)
      processor.process(message, &block)
      if processor.apoptosis_mode
        message_processors.delete(message.from)
      end
    end

    def message_processors_for(jid)
      message_processors[jid.to_s] ||= MessageProcessor.new(jid)
    end

    def w
      message_processors.values.map do |mp|
        [mp.jid.to_s, mp.state, mp.user_id, ! mp.apoptosis_mode].inspect
      end.join("\n")
    end

  end
end
