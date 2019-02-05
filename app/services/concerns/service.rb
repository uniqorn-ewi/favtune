module Service
  extend ActiveSupport::Concern

  included do
    private_class_method :new
  end

  class_methods do
    def call(*args)
      instance = new(*args)
      yield(instance) if block_given?
      instance.send(:call)
    end
  end

  private

  def initialize(*args)
    return if args.empty?

    raise(NotImplementedError, 'You must implement #{self.class}##{__method__}')
  end

  def call
    raise(NotImplementedError, 'You must implement #{self.class}##{__method__}')
  end
end
