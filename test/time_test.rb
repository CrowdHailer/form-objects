require 'date'
require './test/test_helper'
require './lib/time'

def html_date(datetime)
  datetime.strftime('%Y-%m-%d')
end

def html_time(datetime)
  datetime.strftime('%H:%M')
end

class TimeTest < MiniTest::Test
  def test_date_helper
    datetime = DateTime.new(2010,05,18)
    assert_equal '2010-05-18', html_date(datetime)
  end

  def test_time_helpers
    datetime = DateTime.new(2010,05,18,05,50)
    assert_equal '05:50', html_time(datetime)
  end

  def test_working_date
    datetime = DateTime.new(2010,05,18,05,50)
    form = DateForm.new 'occurance' => {'date' => html_date(datetime), 'time' => html_time(datetime)}
    assert_equal datetime, form[:occurance]
  end

  def test_missing_date
    err = assert_raises Virtus::CoercionError do
      DateForm.new 'occurance' => {'time' => '10:20'}
    end
    assert_equal "Failed to coerce attribute `occurance' from {\"time\"=>\"10:20\"} into DateTime", err.message
  end

  def test_misformed_date
    err = assert_raises Virtus::CoercionError do
      DateForm.new 'occurance' => {'date' => 's-t', 'time' => '10:20'}
    end
    assert_equal "Failed to coerce attribute `occurance' from {\"date\"=>\"s-t\", \"time\"=>\"10:20\"} into DateTime", err.message
  end

  def test_can_set_default_date
    coercer = FormDateCoercer.new default_date: DateTime.new(2000,1,1)
    result = coercer.call 'time' => '10:20'
    assert_equal DateTime.new(2000,1,1,10,20), result
  end

  def test_can_set_default_time 
    coercer = FormDateCoercer.new default_time: DateTime.new(2000,1,1,12,30)
    result = coercer.call 'date' => '2011-04-04'
    assert_equal DateTime.new(2011,4,4,12,30), result
  end
end