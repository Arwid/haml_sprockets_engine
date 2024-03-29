require 'haml_sprockets_engine/version'
require 'tilt'
require 'sprockets'
require 'haml'

module HamlSprocketsEngine

  # require 'sprockets'
  # require 'tilt'

  class HamlSprockets < Tilt::Template
    require 'haml'

    def self.engine_initialized?
      defined? ::Haml::Engine
    end

    def self.default_mime_type
      'application/javascript'
    end    

    def initialize_engine
      require_template_library 'haml'
    end

    def prepare
      @engine = ::Haml::Engine.new(data, options)
    end

    def evaluate(scope, locals, &block)
      if @engine.respond_to?(:precompiled_method_return_value, true)
        super
      else
        @engine.render(scope, locals, &block)
      end
    end

    # Precompiled Haml source. Taken from the precompiled_with_ambles
    # method in Haml::Precompiler:
    # http://github.com/nex3/haml/blob/master/lib/haml/precompiler.rb#L111-126
    def precompiled_template(locals)
      @engine.precompiled
    end

    def precompiled_preamble(locals)
      local_assigns = super
      @engine.instance_eval do
        <<-RUBY
          begin
            extend Haml::Helpers
            _hamlout = @haml_buffer = Haml::Buffer.new(@haml_buffer, #{options_for_buffer.inspect})
            _erbout = _hamlout.buffer
            __in_erb_template = false #true
            _haml_locals = locals
            #{local_assigns}
        RUBY
      end
    end

    def precompiled_postamble(locals)
      @engine.instance_eval do
        <<-RUBY
            #{precompiled_method_return_value}
          ensure
            @haml_buffer = @haml_buffer.upper
          end
        RUBY
      end
    end
  end
end

Sprockets::Engines
Sprockets.register_engine '.haml', HamlSprocketsEngine::HamlSprockets

# if Rails
#   Rails.application.assets.register_engine '.haml', HamlSprocketsEngine::HamlSprockets
# else
#   Sprockets.register_engine '.haml', HamlSprocketsEngine::HamlSprockets
# end


require 'haml_sprockets_engine/engine' if defined?(Rails)

