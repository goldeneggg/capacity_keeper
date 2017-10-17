require 'spec_helper'

describe CapacityKeeper::Plugin do
  let(:plugin) { DefaultConfigKeeper.new(opts: opts) }
  let(:plugin2) { OtherKeeper.new(opts: opts) }
  let(:opts) { valid_opts }
  let(:valid_opts) { { performable_str: 'test' } }

  describe '#initialize' do
    context 'when not have undefined key' do
      it 'should be initialized correctly' do
        ms = plugin.class.singleton_methods
        expect(ms.size).to eq(8)
        expect(ms.include?(:configs)).to be_truthy
        expect(ms.include?(:config)).to be_truthy
      end
    end
  end

  describe '#lock' do
    it 'should change capacity state' do
      plugin.lock
      expect(plugin.class.class_variable_get(:@@state)).to eq('lock')
    end
  end

  describe '#unlock' do
    it 'should change capacity state' do
      plugin.unlock
      expect(plugin.class.class_variable_get(:@@state)).to eq(plugin.configs[:performable_str])
    end
  end

  describe '#name' do
    subject{ plugin.name }

    it 'should be returned class name' do
      expect(subject).to eq('DefaultConfigKeeper')
    end
  end

  describe '#retry_count' do
    subject{ test_plugin.retry_count }

    context 'when plugin is DefaultConfigKeeper' do
      let(:test_plugin) { plugin }

      it 'should be returned default value' do
        expect(subject).to eq(CapacityKeeper::Config.retry_count)
      end
    end

    context 'when plugin is OtherKeeper' do
      let(:test_plugin) { plugin2 }

      it 'should be returned assigned config value' do
        expect(subject).to eq(10)
      end
    end
  end

  describe '#retry_interval_second' do
    subject{ test_plugin.retry_interval_second }

    context 'when plugin is DefaultConfigKeeper' do
      let(:test_plugin) { plugin }

      it 'should be returned default value' do
        expect(subject).to eq(CapacityKeeper::Config.retry_interval_second)
      end
    end

    context 'when plugin is OtherKeeper' do
      let(:test_plugin) { plugin2 }

      it 'should be returned assigned config value' do
        expect(subject).to eq(10)
      end
    end
  end

  describe '#raise_on_retry_fail?' do
    subject{ test_plugin.raise_on_retry_fail? }

    context 'when plugin is DefaultConfigKeeper' do
      let(:test_plugin) { plugin }

      it 'should be returned default value' do
        expect(subject).to eq(CapacityKeeper::Config.raise_on_retry_fail)
      end
    end

    context 'when plugin is OtherKeeper' do
      let(:test_plugin) { plugin2 }

      it 'should be returned assigned config value' do
        expect(subject).to eq(true)
      end
    end
  end

  describe '#logger' do
    subject{ plugin.logger }

    it 'should be returned default value' do
      expect(subject).to eq(CapacityKeeper::Config.logger)
    end
  end

  describe '#verbose?' do
    subject{ test_plugin.verbose? }

    context 'when plugin is DefaultConfigKeeper' do
      let(:test_plugin) { plugin }

      it 'should be returned default value' do
        expect(subject).to eq(CapacityKeeper::Config.verbose)
      end
    end

    context 'when plugin is OtherKeeper' do
      let(:test_plugin) { plugin2 }

      it 'should be returned assigned config value' do
        expect(subject).to eq(true)
      end
    end
  end

  describe '#configs' do
    subject{ test_plugin.configs }

    context 'when plugin is DefaultConfigKeeper' do
      let(:test_plugin) { plugin }

      it 'should be returned class configs' do
        expect(subject).to eq(test_plugin.class.configs)
      end
    end

    context 'when plugin is OtherKeeper' do
      let(:test_plugin) { plugin2 }

      it 'should be returned class configs' do
        expect(subject).to eq(test_plugin.class.configs)
      end
    end
  end

  describe '#config' do
    context 'when config is overrided' do
      before(:each) do
        OtherKeeper.config :test_val, 30
      end

      it 'should be returned overrided config value' do
          expect(plugin2.configs[:test_val]).to eq(30)
      end
    end
  end
end
