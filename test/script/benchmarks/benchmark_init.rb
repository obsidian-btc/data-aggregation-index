ENV['LOG_LEVEL'] ||= 'info'

require_relative '../script_init'

def measure(stream_name, dispatcher_cls)
  dispatcher = dispatcher_cls.build
  reader = EventStore::Messaging::Reader.build stream_name, dispatcher

  t0 = Time.now

  i = 0
  reader.start do
    i += 1
    __logger.info "Handled message ##{i}"
  end

  t1 = Time.now

  elapsed_time = t1 - t0
  __logger.info "Handled #{i} messages in #{elapsed_time.round 2} secs"
  __logger.info "Throughput: #{(i / elapsed_time).round 2} units / sec"
end
