project(
  'audio',
  'c',
  meson_version : '>= 1.3.0',
  version : '0.1',
  default_options : ['warning_level=3', 'c_std=gnu11'],
)

dependencies = [
  dependency('libpipewire-0.3'),
]

sources = [
  'main.c',
]

exe = executable(
  'audio',
  sources,
  dependencies : dependencies,
  install : true,
)

test('basic', exe)
