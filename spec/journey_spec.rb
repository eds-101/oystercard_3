require 'journey'

describe Journey do
  
  describe '#journey' do
    it "starts a new journey" do
      expect(subject.in_journey).to be true
    end

  end
end

      # stuff
      # oyster.touch_in(:entry_station)

# starting a journey, 
# finishing a journey, 
# calculating the fare of a journey, 
# returning whether or not the journey is complete

=begin

Oyster - touch in(station)
    Provokes Journey.new 
    Provokes Station.new (Oyster_station)
    Journey.in_journey (= true)


=end
