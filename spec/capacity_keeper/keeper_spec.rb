require 'spec_helper'

describe CapacityKeeper::Keeper do
  let(:keeper) { DefaultConfigKeeper.new(opts: opts) }
  let(:keeper2) { OtherKeeper.new(opts: opts) }
  let(:opts) { valid_opts }
  let(:valid_opts) { { performable_str: 'test' } }

  describe '#initialize' do
    context 'when not have undefined key' do
      it 'should be initialized correctly' do
        ms = keeper.class.singleton_methods
        expect(ms.size).to eq(8)
        expect(ms.include?(:configs)).to be_truthy
        expect(ms.include?(:config)).to be_truthy
      end
    end
  end

  describe '#before' do
    it 'should change capacity state' do
      keeper.before
      expect(keeper.state).to eq('lock')
    end
  end

  describe '#after' do
    context 'when before was called beforehand' do
      before(:each) do
        keeper.before
      end

      it 'should change capacity state' do
        keeper.after
        expect(keeper.state).to eq(keeper.configs[:performable_str])
      end
    end

    context 'when before was not called beforehand' do
      it 'should not change capacity state' do
        keeper.after
        expect(keeper.state).to eq('unlock')
      end
    end
  end

  describe '#beginning?' do
    subject{ keeper.beginning? }

    context 'when before was called but after was not called' do
      before(:each) do
        keeper.before
      end

      it 'should be truthy' do
        is_expected.to be_truthy
      end
    end
  end

  describe '#name' do
    subject{ keeper.name }

    it 'should be returned class name' do
      expect(subject).to eq('DefaultConfigKeeper')
    end
  end

  describe '#retry_count' do
    subject{ test_keeper.retry_count }

    context 'when keeper is DefaultConfigKeeper' do
      let(:test_keeper) { keeper }

      it 'should be returned default value' do
        expect(subject).to eq(CapacityKeeper::Config.retry_count)
      end
    end

    context 'when keeper is OtherKeeper' do
      let(:test_keeper) { keeper2 }

      it 'should be returned assigned config value' do
        expect(subject).to eq(10)
      end
    end
  end

  describe '#retry_interval_second' do
    subject{ test_keeper.retry_interval_second }

    context 'when keeper is DefaultConfigKeeper' do
      let(:test_keeper) { keeper }

      it 'should be returned default value' do
        expect(subject).to eq(CapacityKeeper::Config.retry_interval_second)
      end
    end

    context 'when keeper is OtherKeeper' do
      let(:test_keeper) { keeper2 }

      it 'should be returned assigned config value' do
        expect(subject).to eq(10)
      end
    end
  end

  describe '#raise_on_retry_fail?' do
    subject{ test_keeper.raise_on_retry_fail? }

    context 'when keeper is DefaultConfigKeeper' do
      let(:test_keeper) { keeper }

      it 'should be returned default value' do
        expect(subject).to eq(CapacityKeeper::Config.raise_on_retry_fail)
      end
    end

    context 'when keeper is OtherKeeper' do
      let(:test_keeper) { keeper2 }

      it 'should be returned assigned config value' do
        expect(subject).to eq(true)
      end
    end
  end

  describe '#logger' do
    subject{ keeper.logger }

    it 'should be returned default value' do
      expect(subject).to eq(CapacityKeeper::Config.logger)
    end
  end

  describe '#verbose?' do
    subject{ test_keeper.verbose? }

    context 'when keeper is DefaultConfigKeeper' do
      let(:test_keeper) { keeper }

      it 'should be returned default value' do
        expect(subject).to eq(CapacityKeeper::Config.verbose)
      end
    end

    context 'when keeper is OtherKeeper' do
      let(:test_keeper) { keeper2 }

      it 'should be returned assigned config value' do
        expect(subject).to eq(true)
      end
    end
  end

  describe '#configs' do
    subject{ test_keeper.configs }

    context 'when keeper is DefaultConfigKeeper' do
      let(:test_keeper) { keeper }

      it 'should be returned class configs' do
        expect(subject).to eq(test_keeper.class.configs)
      end
    end

    context 'when keeper is OtherKeeper' do
      let(:test_keeper) { keeper2 }

      it 'should be returned class configs' do
        expect(subject).to eq(test_keeper.class.configs)
      end
    end
  end

  describe '#config' do
    context 'when config is overrided' do
      before(:each) do
        OtherKeeper.config :test_val, 30
      end

      it 'should be returned overrided config value' do
          expect(keeper2.configs[:test_val]).to eq(30)
      end
    end
  end
end
