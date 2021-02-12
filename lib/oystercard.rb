require_relative 'journey'
require_relative 'station'

class OysterCard
  attr_reader :balance, :limit, :entry_station, :exit_station, :journey

  DEFAULT_LIMIT = 90
  MIN_TRAVEL_BALANCE = 1
  MIN_FARE = 1

  def initialize
    @balance = 0
    @limit = DEFAULT_LIMIT
    @in_use = false
    @entry_station = nil
    @exit_station = nil
  #  @journeys = []
    @journey
  end

  def top_up(amount)
    raise "Limit of £#{:limit} exceeded: payment rejected." if @balance + amount >= @limit
    if @balance + amount < @limit then @balance += amount
    end
  end

  def deduct(amount)
      @balance -= amount
end

  def touch_in(station)
    raise "Insufficient funds" if @balance < MIN_TRAVEL_BALANCE

    @new_entry_station = Station.new
    @new_entry_station.name = station
    @journey = Journey.new
    #@journey.in_journey currently equals true
    # @in_use = true
    #@entry_station = @new_entry_station.name
    started_journey = { entry: @new_entry_station, exit: nil }
    #@journey.journeys << started_journey
    @journey.journeys << started_journey
  end

  def touch_out(exit_station)
    @in_use = false
    deduct(MIN_FARE)
    @journeys.last[:exit] = exit_station
  end

  def in_journey?
    @journey.in_journey
  end

end
