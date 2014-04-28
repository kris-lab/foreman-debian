Gem::Specification.new do |s|
  s.name = 'foreman_debian'
  s.version = '0.0.1'
  s.summary = 'Foreman wrapper for debian'
  s.description = 'Wrapper around foreman and Procfile concept. It implements basic exporting, installing and uninstalling of initd scripts and monit configs for debian.'
  s.authors = %w(cargomedia tomaszdurka)
  s.email = 'hello@cargomedia.ch'
  s.date = Date.today.to_s
  s.homepage = 'https://github.com/cargomedia/foreman-debian'
  s.license = 'MIT'

  s.files = Dir.glob 'lib/**/*'
  s.executables = ['foreman-debian']

  s.add_runtime_dependency 'clamp', '>= 0.5'
  s.add_runtime_dependency 'foreman', '>= 0.63.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '>= 2.0'
  s.add_development_dependency 'fakefs', '>= 0.4.3'
end
