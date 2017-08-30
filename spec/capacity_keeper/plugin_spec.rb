require 'spec_helper'

describe CapacityKeeper::Plugin do
  let(:plugin) { ExampleKeeper.new(opts: opts) }
  let(:opts) { valid_opts }
  let(:valid_opts) { { default_is_nil: 'a', reservable_str: 'test' } }

  describe '#initialize' do
    context 'when not have undefined key' do
      it 'should be initialized correctly' do
        ms = plugin.class.singleton_methods
        expect(ms.size).to eq(3)  # Targets are 2 gem methods + "yaml_tag" methods
        expect(ms.include?(:configs)).to be_truthy
        expect(ms.include?(:config)).to be_truthy
      end
    end
  end

  describe '#deposit' do
    it 'should change capacity state' do
      plugin.deposit
      expect(plugin.class.class_variable_get(:@@state)).to eq('deposit')
    end
  end

  describe '#reposit' do
    it 'should change capacity state' do
      plugin.reposit
      expect(plugin.class.class_variable_get(:@@state)).to eq(plugin.configs[:reservable_str])
    end
  end

  describe '#name' do
    subject{ plugin.name }

    it 'should be returned class name' do
      expect(subject).to eq('ExampleKeeper')
    end
  end

  describe '#retry_count' do
    subject{ plugin.retry_count }

    context 'when not assigned initializer' do
      it 'should be returned default value' do
        expect(subject).to eq(CapacityKeeper::Config.retry_count)
      end
    end

    context 'when assigned initializer' do
      let(:opts) { valid_opts.merge({ retry_count: 20 })}
      it 'should be returned overrided value' do
        expect(subject).to eq(opts[:retry_count])
      end
    end
  end

  describe '#retry_sleep_second' do
    subject{ plugin.retry_sleep_second }

    context 'when not assigned initializer' do
      it 'should be returned default value' do
        expect(subject).to eq(CapacityKeeper::Config.retry_sleep_second)
      end
    end

    context 'when assigned initializer' do
      let(:opts) { valid_opts.merge({ retry_sleep_second: 15 })}
      it 'should be returned overrided value' do
        expect(subject).to eq(opts[:retry_sleep_second])
      end
    end
  end

  describe '#raise_on_retry_fail?' do
    subject{ plugin.raise_on_retry_fail? }

    context 'when not assigned initializer' do
      it 'should be returned default value' do
        expect(subject).to eq(CapacityKeeper::Config.raise_on_retry_fail)
      end
    end

    context 'when assigned initializer' do
      let(:opts) { valid_opts.merge({ raise_on_retry_fail: true })}
      it 'should be returned overrided value' do
        expect(subject).to eq(opts[:raise_on_retry_fail])
      end
    end
  end

  describe '#logger' do
    subject{ plugin.logger }

    context 'when not assigned initializer' do
      it 'should be returned default value' do
        expect(subject).to eq(CapacityKeeper::Config.logger)
      end
    end

    context 'when assigned initializer' do
      let(:opts) { valid_opts.merge({ logger: ::Logger.new(STDERR) })}
      it 'should be returned overrided value' do
        expect(subject).to eq(opts[:logger])
      end
    end
  end

  describe '#verbose?' do
    subject{ plugin.verbose? }

    context 'when not assigned initializer' do
      it 'should be returned default value' do
        expect(subject).to eq(CapacityKeeper::Config.verbose)
      end
    end

    context 'when assigned initializer' do
      let(:opts) { valid_opts.merge({ verbose: true })}
      it 'should be returned overrided value' do
        expect(subject).to eq(opts[:verbose])
      end
    end
  end

  describe '#configs' do
    subject{ plugin.configs }

    context 'when not assigned initializer' do
      it 'should be returned default value' do
        expect(subject).to eq(plugin.class.configs.merge(valid_opts))
      end
    end
  end
end
