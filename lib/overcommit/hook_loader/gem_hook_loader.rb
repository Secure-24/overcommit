# frozen_string_literal: true

module Overcommit::HookLoader
  # Responsible for loading hooks that ship with Overcommit.
  class GemHookLoader < Base
    def load_hooks
      @config.enabled_gem_hooks(@context).map do |hook_name|
        underscored_hook_name = Overcommit::Utils.snake_case(hook_name)
        require "overcommit/hook/#{@context.hook_type_name}/#{underscored_hook_name}"
        create_hook(hook_name)
      end
    end
  end
end
