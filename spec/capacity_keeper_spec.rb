require 'spec_helper'

describe CapacityKeeper do
  let(:include_class) {
    c = Class.new
    c.send(:include, CapacityKeeper)
  }

  describe 'VERSION' do
    it 'should have a correct version number' do
      expect(CapacityKeeper::VERSION).to eq('0.0.1')
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

  describe '#add_keeper' do
    subject {
      instance.
      send(:with_capacity, opts: opts).
      send(:add_keeper, keeper: ExampleKeeper).
      send(:add_keeper, keeper: OtherKeeper) { block_result }
    }

    let(:instance) { include_class.new }
    let(:block_result) { 'block_is_exected' }

    before(:each) do
      allow_any_instance_of(Kernel).to receive(:sleep)
    end

    describe 'retry and exec' do
      let(:opts) { { var: 1, var_required: "abc" } }

      context 'when capacity is satisfied' do
        it 'should be exected immediately' do
          expect_any_instance_of(Kernel).not_to receive(:sleep)
          expect_any_instance_of(ExampleKeeper).to receive(:reduce_capacity)
          expect_any_instance_of(OtherKeeper).to receive(:reduce_capacity)
          expect_any_instance_of(ExampleKeeper).to receive(:gain_capacity)
          expect_any_instance_of(OtherKeeper).to receive(:gain_capacity)
          is_expected.to eq(block_result)
        end
      end

      context 'when capacity is not satisfied and over retry limit' do
        let(:retry_occured_configs) { { satisfied_str: "not_satisfied" } }

        context 'when raise_on_retry_fail is true' do
          let(:opts) { { var: 1, var_required: "abc" }.merge(merge_configs) }
          let(:merge_configs) { retry_occured_configs.merge({ raise_on_retry_fail: true }) }

          it 'should be raised error' do
            expect_any_instance_of(Kernel).to receive(:sleep).at_least(:once)
            expect{ subject }.to raise_error(CapacityKeeper::Errors::OverRetryLimitError)
          end
        end

        context 'when raise_on_retry_fail is false' do
          let(:opts) { { var: 1, var_required: "abc" }.merge(merge_configs) }
          let(:merge_configs) { retry_occured_configs }
          it 'should be exected with sleep' do
            expect_any_instance_of(Kernel).to receive(:sleep).at_least(:once)
            is_expected.to eq(block_result)
          end
        end
      end
    end
  end
end
