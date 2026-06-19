project(
  'sway-status',
  'c',
  meson_version : '>= 1.3.0',
  version : '0.1',
  default_options : [
    'warning_level=2',
    'c_std=gnu11',
    ],
)

include_dir = include_directories('include')

nm_dep = dependency('libnm')
wp_dep = dependency('wireplumber-0.5')
dependencies = [
  wp_dep,
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

pw_test = executable(
  'pw_test',
  files('test/pipewire.c'),
  dependencies : wp_dep,
)

nm_test = executable(
  'nm_test',
  files('test/network.c'),
  dependencies : nm_dep,
)
