class Oystercard
  LIMIT = 90
  MINIMUM_BALANCE = 1
  attr_reader :balance, :entry_station, :journeys

  def initialize(balance = 0)
    @balance = balance
    @entry_station = nil
    @journeys = []
    @journey = Hash.new
  end

  def top_up(amount)
    @balance + amount <= LIMIT ? @balance += amount : exceeds_balance
  end

  def touch_in(station)
    raise "Does not have the minimum amount" if @balance < MINIMUM_BALANCE
    @entry_station = station
    @journey["entry_station"] = station
  end

  def touch_out(station)
    if in_journey?
      deduct(MINIMUM_BALANCE)
      @entry_station = nil
      @journey["exit_station"] = station
      @journeys << @journey
      @journey = Hash.new
    end
  end

  private
  def exceeds_balance
    raise "Exceeds balance limit of #{LIMIT}"
  end

  def in_journey?
    @entry_station != nil
  end

  def deduct(amount)
    @balance -= amount
  end

end
