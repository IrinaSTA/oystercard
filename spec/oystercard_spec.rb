require 'oystercard'
require 'pry'
require 'station'

describe Oystercard do
  let(:station) { double :station }
  let(:station2) { double :station2 }

  it "starts with a balance of 0" do
    expect(subject.balance).to eq(0)
  end

  it 'can be topped up' do
    subject.topup(15)
    expect(subject.balance).to eq 15
  end

  it 'cannot store a balance above £90' do
    expect { subject.topup(91) }.to raise_error "Cannot topup £91: maximum balance of £#{Oystercard::MAXIMUM_BALANCE}"
  end

  # it 'will deduct a fare' do
  #   subject.topup(10)
  #   subject.deduct(5)
  #   expect(subject.balance).to eq (5)
  # end

  it 'can touch in at the beginning of a journey' do
    subject.topup(10)
    expect(subject.touch_in(station)).to eq(station)
  end

  it 'can touch out at the end of a journey' do
    expect(subject.touch_out(station)).to eq(nil)
  end

  it 'knows when the user is in transit' do
    subject.topup(10)
    subject.touch_in(station)
    expect(subject).to be_in_journey
  end

  it 'does not allow user to touch in if balance is below minimum' do
    expect{ subject.touch_in(station) }.to raise_error 'Insufficient funds'
  end

  it 'charges the user £1 on touching out' do
    subject.topup(10)
    subject.touch_in(station)
    expect { subject.touch_out(station) }.to change { subject.balance }.by(-Oystercard::MINIMUM_FARE)
  end

  it 'keeps a record of the starting station' do
    subject.topup(10)
    subject.touch_in(station)
    expect(subject.start_station).to eq(station)
  end

  it 'forgets entry station on touch out' do
    subject.topup(10)
    subject.touch_in(station)
    subject.touch_out(station)
    expect(subject.start_station).to be_nil
  end

  it 'shows all previous trips' do
    subject.topup(10)
    subject.touch_in(station)
    subject.touch_out(station2)
    expect(subject.trips[0]["Start:"]).to eq(station)
    expect(subject.trips[0]["End:"]).to eq(station2)
  end

  it "has an empty list of journeys by default" do
    expect(subject.trips).to be_empty
  end

end
