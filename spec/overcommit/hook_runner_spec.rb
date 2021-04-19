# frozen_string_literal: true

require 'spec_helper'

describe Overcommit::HookRunner do
  let(:hash) { {} }
  let(:config) { Overcommit::Configuration.new(hash) }
  let(:logger) { double('logger') }
  let(:context) { double('context') }
  let(:printer) { double('printer') }
  let(:runner) { described_class.new(config, logger, context, printer) }

  describe '#load_hooks' do
    subject(:load_hooks) { runner.send(:load_hooks) }

    before do
      context.stub(hook_class_name: 'PreCommit',
                   hook_type_name: 'pre_commit')
      allow_any_instance_of(Overcommit::HookLoader::BuiltInHookLoader).
        to receive(:load_hooks).and_return([])
      allow_any_instance_of(Overcommit::HookLoader::PluginHookLoader).
        to receive(:load_hooks).and_return([])
    end

    context 'when gem_plugins is disabled' do
      let(:hash) do
        {
          'gem_plugins' => false
        }
      end

      it 'expects not to load Gem hooks' do
        expect_any_instance_of(Overcommit::HookLoader::GemHookLoader).
          not_to receive(:load_hooks)
        load_hooks
      end
    end

    context 'when gem_plugins is enabled' do
      let(:hash) do
        {
          'gem_plugins' => true
        }
      end
      let(:gemhookloader) { Overcommit::HookLoader::GemHookLoader.new(config, context, logger) }

      it 'expects to load Gem hooks' do
        expect_any_instance_of(Overcommit::HookLoader::GemHookLoader).
          to receive(:load_hooks).and_call_original
        load_hooks
      end
    end
  end
end
