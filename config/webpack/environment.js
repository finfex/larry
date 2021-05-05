const { environment, config } = require('@rails/webpacker')

const { add_paths_to_environment } = require(
  `${environment.plugins.get('Environment').defaultValues["PWD"]}/config/environments/_add_gem_paths`
)

add_paths_to_environment(environment)

module.exports = environment
