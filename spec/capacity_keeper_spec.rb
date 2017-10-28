require 'spec_helper'

describe CapacityKeeper do
  let(:include_class) {
    c = Class.new
    c.send(:include, CapacityKeeper)
  }

  describe 'VERSION' do
    it 'should have a correct version number' do
      expect(CapacityKeeper::VERSION).to eq('0.0.4')
    end
  end

  describe '#configure' do
    before(:each) do
      CapacityKeeper::Config.retry_count = 123
    end

    it 'should be a CapacityKeeper::Config' do
      CapacityKeeper.configure do |config|
        expect(config).to be_a(CapacityKeeper::Config)
      end
    end

    it 'should be able to refer through CapacityKeeper::Config' do
      expect(CapacityKeeper::Config.retry_count).to eq(123)
    end
  end

  describe '#add_plugin' do
    subject {
      instance.
      send(:within_capacity, opts: opts).
      send(:add_plugin, DefaultConfigKeeper).
      send(:add_plugin, OtherKeeper) { block_result }
    }

    let(:instance) { include_class.new }
    let(:block_result) { 'block_is_exected' }

    before(:each) do
      allow_any_instance_of(Kernel).to receive(:sleep)
    end

    describe 'retry and exec' do
      let(:opts) { { var: 1 } }

      context 'when capacity is performable' do
        it 'should be exected immediately' do
          expect_any_instance_of(Kernel).not_to receive(:sleep)
          expect_any_instance_of(DefaultConfigKeeper).to receive(:lock)
          expect_any_instance_of(OtherKeeper).to receive(:lock)
          expect_any_instance_of(DefaultConfigKeeper).to receive(:unlock)
          expect_any_instance_of(OtherKeeper).to receive(:unlock)
          is_expected.to eq(block_result)
        end
      end

      context 'when capacity is not performable' do
        let(:opts) { { var: 1, performable_str: 'not_performable' } }

        it 'should be raised error' do
          expect_any_instance_of(Kernel).to receive(:sleep).at_least(:once)
          expect{ subject }.to raise_error(CapacityKeeper::Errors::OverRetryLimitError)
        end
      end
    end
  end
end
