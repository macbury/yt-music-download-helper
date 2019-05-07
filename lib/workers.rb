require 'thread'
require 'singleton'

class Workers
  include Singleton

  attr_reader :queue

  def initialize
    @queue = Queue.new
    @thread = Thread.new { process_jobs }
    @thread.run
  end

  def self.push(job)
    instance.queue.push(job)
  end

  def size
    queue.size + (@task ? 1 : 0)
  end

  private

  def process_jobs
    loop do
      if queue.empty?
        sleep 1
      else
        @task = queue.shift(true)
        @task.call
        @task = nil
      end
    end
  end
end