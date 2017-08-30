require 'spec_helper'

describe CapacityKeeper::Plugins::SimpleCounter do
  before(:each) do
    allow(Kernel).to receive(:sleep)
  end

  describe 'plugin methods' do
    context 'when capacity control is valid' do
      class PluginTest
        include CapacityKeeper

        attr_reader :idx

        def initialize
          @idx = 0
        end

        def test_method(opts = {})
          within_capacity(plugin: CapacityKeeper::Plugins::SimpleCounter, opts: opts) do
            @idx += 1
          end
        end
      end

      let(:instance) { PluginTest.new }
      let(:opts) { {} }

      it 'should finish capacity_keeped method validly' do
        (1..11).each do |idx|
          expect(instance.test_method(opts)).to eq(idx)
        end

        expect(instance.idx).to eq(11)
        expect(CapacityKeeper::Plugins::SimpleCounter.counter).to eq(0)
      end
    end
  end
end
