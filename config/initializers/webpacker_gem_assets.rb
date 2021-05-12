# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Source: https://gist.github.com/justinvdk/b8b40a9b8a22e32275bb846590883cbf

def default_assets_path(gem)
  case gem
  when 'best_in_place'
    'lib/assets/javascripts'
  else
    'app/assets/javascripts'
  end
end

def output_path
  Webpacker.config.send(:data)[:resolved_gems_output_path] || 'config/environments/_add_gem_paths.js'
end

def resolve_gem_path(gem)
  if gem.present?
    gem_path = Gem.loaded_specs[gem]&.full_gem_path
    return "#{gem_path}/#{default_assets_path(gem)}" if gem_path.present?
  end
  abort("Gem '#{gem}' not found, please check webpacker config (#{Webpacker.config.config_path})")
end

buffer = []
buffer << "
/*
 * THIS IS A GENERATED FILE.
 * DO NOT CHECK IT INTO SOURCE CONTROL
 */
function add_paths_to_environment(environment) {".strip

resolved_gems = Webpacker.config.send(:data)[:resolved_gems]
if resolved_gems.any?
  buffer << "\n  environment.resolvedModules.add(\n"
  buffer << resolved_gems.map do |gem|
    "    { key: 'gem-#{gem}', value: '#{resolve_gem_path(gem)}' }"
  end.join(",\n")
  buffer << "\n  )\n"
end

buffer << "}\nexports.add_paths_to_environment = add_paths_to_environment\n"

File.write(
  output_path,
  buffer.join
)

module WebpackerGemAssets
  def resolved_paths
    send(:data)[:resolved_gems].map do |gem|
      resolve_gem_path gem
    end.compact.concat(super)
  end
end

module Webpacker
  class Configuration
    prepend WebpackerGemAssets
  end
end
