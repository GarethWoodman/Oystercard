require './lib/oystercard'

describe Oystercard do
  limit = Oystercard::LIMIT
  let(:entry_station) {double(:station, :name => "Camden")}
  let(:exit_station) {double(:station, :name => "Angel")}


  context "need top up" do

    before :each do
      subject.top_up(50)
    end

    it "has a balance" do
      expect(subject).to respond_to(:balance)
    end

    it "can store journeys" do
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journeys.count).to eq 1
    end

    it "has no journeys stored" do
      expect(subject.journeys.count).to eq 0
    end

    it "stores a journey when touched in and touched out" do
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journeys[0]["entry_station"].name).to eq "Camden"
      expect(subject.journeys[0]["exit_station"].name).to eq "Angel"
    end

    describe "top_up method" do
      it "tops up the card with a specified balance" do
        expect(subject.balance).to eq 50
      end

      it "returns exceed limit error if top_up exceeds balance limit of #{limit}" do
        expect { subject.top_up(50) }.to raise_error("Exceeds balance limit of #{limit}")
      end


    end

    it "deducts specified amount of money from the card" do
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.balance).to eq 49
    end

    it "checks that it can be touched in" do
      expect(subject).to respond_to(:touch_in).with(1).argument
    end

    describe "#touch_out" do
      it "deducts correct amount for journey" do
        subject.touch_in(entry_station)
        expect { subject.touch_out(exit_station) }.to change{subject.balance}.by(-1)
      end
    end

    it "remebers station when touched in" do
      subject.touch_in(entry_station)
      expect(subject.entry_station.name).to eq("Camden")
    end

    it "forgets station when touched out" do
      subject.touch_in(entry_station)
      expect { subject.touch_out(exit_station) }.to change{subject.entry_station}.to(nil)
    end
  end

  context "don't need top up" do
    it "returns error when touching in if balance is less than minimum amount" do
      subject.top_up(0.5)
      expect { subject.touch_in(entry_station) }.to raise_error("Does not have the minimum amount")
    end
  end
end
