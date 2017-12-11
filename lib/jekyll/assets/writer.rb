# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module SprocketsExportersFileExporterPatches
  def skip?(logger)
    return true if File.exist?(target)
    logger.debug "Writing asset to #{target}"
    false
  end

  # --
  def call
    before_hook(asset, env: environment)
    after_hook(out = super, {
      env: environment, asset: asset
    })

    out
  end

  # --
  private
  def before_hook(asset, env:)
    Jekyll::Assets::Hook.trigger :asset, :before_write do |v|
      v.call(asset, env)
    end
  end

  # --
  private
  def after_hook(out, asset:, env:)
    Jekyll::Assets::Hook.trigger :asset, :after_write do |v|
      v.call(out, asset, env)
    end
  end
end

# --
module Sprockets
  module Exporters
    class FileExporter
      prepend SprocketsExportersFileExporterPatches
    end
  end
end
