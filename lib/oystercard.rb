require 'pry'
require 'journey'

class Oystercard

  attr_reader :balance, :start_station, :trips

  MINIMUM_BALANCE = 1
  MAXIMUM_BALANCE = 90
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
    @trips = []
  end

  def topup(amount)
    raise "Cannot topup £#{amount}: maximum balance of £#{MAXIMUM_BALANCE}" if (MAXIMUM_BALANCE - @balance) < amount
    @balance += amount
  end

  def touch_in(station)
    raise 'Insufficient funds' if @balance < MINIMUM_BALANCE
    @current_journey = Journey.new
    @current_journey.start(station)
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    @current_journey.finish(station)
  end

  def in_journey?
    true if @start_station != nil
  end

  private

  def deduct(amount)
    @balance -= amount
  end

end
