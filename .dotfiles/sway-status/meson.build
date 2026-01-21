project(
  'sway-status',
  'c',
  meson_version : '>= 1.3.0',
  version : '0.1',
  default_options : ['warning_level=3'],
)

include_dir = include_directories('include')

dependencies = [
  dependency('wireplumber-0.5'),
]

sources = []
subdir('src')

exe = executable(
  'main',
  sources,
  dependencies : dependencies,
  include_directories : include_dir,
  install : true,
)
