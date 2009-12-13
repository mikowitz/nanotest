module Nanotest
  extend self

  @@failures, @@dots = [], []

  def assert(msg="assertion failed", file=nil, line=nil, &block)
    unless block.call
      file ||= caller.first.split(':')[0]
      line ||= caller.first.split(':')[1]
      self.add_failure(file, line, msg)
    else
      @@dots << '.'
    end
  rescue Exception => e
    self.add_failure(file, line, e.message)
  end

  def add_failure(file, line, message) #:nodoc:
    @@failures << "(%s:%0.3d) %s" % [file, line, message]
    @@dots << 'F'
  end

  def self.results #:nodoc:
    @@dots.join + "\n" + @@failures.join("\n")
  end

  at_exit { puts results unless results.strip.empty? }
end
