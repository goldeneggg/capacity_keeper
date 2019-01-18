require 'spec_helper'

describe CapacityKeeper::Keepers::SimpleCounter do
  before(:each) do
    allow(Kernel).to receive(:sleep)
  end

  describe 'keeper methods' do
    context 'when capacity control is valid' do
      class KeeperTest
        include CapacityKeeper

        attr_reader :idx

        def initialize
          @idx = 0
        end

        def test_method(opts = {})
          within_capacity(keeper: CapacityKeeper::Keepers::SimpleCounter, opts: opts) do
            @idx += 1
          end
        end
      end

      let(:instance) { KeeperTest.new }
      let(:opts) { {} }

      it 'should finish capacity_keeped method validly' do
        (1..11).each do |idx|
          expect(instance.test_method(opts)).to eq(idx)
        end

        expect(instance.idx).to eq(11)
        expect(CapacityKeeper::Keepers::SimpleCounter.counter).to eq(0)
      end
    end
  end
end
