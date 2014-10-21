require 'virtus'

class SplitTime < Virtus::Attribute
  # def coerce(value)
  #   begin
  #     DateTime.new(*value['date'].split('-').map(&:to_i), *value['time'].split(':').map(&:to_i))
      
  #   rescue Exception => e
  #     raise ::Coercible::UnsupportedCoercion
  #   end
  # end
end

class FormDateCoercer
  def initialize(options={})
    @default_date = options[:default_date].strftime('%Y-%m-%d') if options[:default_date]
    @default_time = options[:default_time].strftime('%H:%M') if options[:default_time]
  end
  def call(value)
    date = value.fetch('date', @default_date)
    time = value.fetch('time', @default_time)
    begin
      DateTime.new(*date.split('-').map(&:to_i), *time.split(':').map(&:to_i))
    rescue NoMethodError, ArgumentError
      value
    end
  end

  def success?(primitive, value)
    value.class == primitive
  end
end

class DateForm
  include Virtus.model(:strict => true)

  attribute :occurance, DateTime, coercer: FormDateCoercer.new
end