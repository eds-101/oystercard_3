require 'oystercard'

describe OysterCard do

  describe '#initialize' do
    it "sets an initial balance of 0" do
      expect(subject.balance).to eq 0
    end
    it 'checks that card has empty list of journeys by default' do
      expect(subject.journeys.length).to eq 0
    end
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up) }
    it "allows user to add money to card" do
      expect(subject.top_up(5)).to eq 5
    end
    it "Sets maximum limit on the card" do
      expect{subject.top_up(100)}.to raise_error "Limit of £#{:limit} exceeded: payment rejected."
    end  
    it 'Enables a top up with an amount chosen by the user' do
      expect{subject.top_up(20)}.to change {subject.balance}.by(20)
    end
  end

  describe '#deduct' do
    it 'Enables a deduction to be made from the card' do
      subject.top_up(10)
      expect{subject.deduct(3)}.to change {subject.balance}.by(- 3)
    end
  end

  describe '#touch_in' do
    it { is_expected.to respond_to :touch_in }
    let(:entry_station) { double :entry_station}
    it 'requires at least £1 to successfully tap in' do
      subject.top_up(0.9)
      expect{subject.touch_in(:entry_station)}.to raise_error "Insufficient funds"
    end   
  end
 
  describe '#touch_out' do
    it { is_expected.to respond_to :touch_out }
    it 'deducts min fare when tapping out' do
      min_fare = OysterCard::MIN_FARE
      subject.top_up(min_fare)
      subject.touch_in("Archway")
      expect { subject.touch_out("Borough") }.to change{subject.balance}.by(- min_fare)
    end
    it 'records the exit station on touching out'  do
      min_fare = OysterCard::MIN_FARE
      subject.top_up(min_fare)
      subject.touch_in("Archway")
      subject.touch_out("Borough")
      expect(subject.journeys.first[:exit]).to eq "Borough"   
    end
  end

  
  describe '#in_journey?' do
    it { is_expected.to respond_to :in_journey? }
    let(:entry_station) { double :entry_station}
    it 'Tracks whether card is in use' do
      subject.top_up(1)
      subject.touch_in(:entry_station)
      expect(subject.in_journey?).to eq true
    end
    let(:entry_station) { double :entry_station}
    it 'stores the entry station the user touches in at' do
      subject.top_up(4)
      subject.touch_in(:entry_station)
      expect(subject.entry_station).to eq :entry_station
    end
  end  


  describe 'train station history' do
    let(:started_journey){ {entry: entry_station, exit: nil} }
    let(:completed_journey){ {entry: entry_station, exit: exit_station} }
    before (:each) do
      subject.instance_variable_set(:@balance, 2)
      subject.touch_in(:entry_station)
    end

    it '#2 touches in and out creates one journey' do
      subject.top_up(2)
      subject.touch_in("Archway")
      subject.touch_out("Barnet")
      expect(subject.journeys).to include({entry: "Archway" , exit: "Barnet" })
    end

  end

end

