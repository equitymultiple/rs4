require_relative 'lib/rs4/version'

Gem::Specification.new do |spec|
  spec.name          = 'rs4'
  spec.version       = Rs4::VERSION
  spec.licenses      = ['GPL-3.0-only']
  spec.authors       = ['donny']
  spec.email         = ['donny@equitymultiple.com']

  spec.summary       = 'Ruby client for the RightSignature 4 Rest API'
  spec.description   = 'Provides ruby access to CRUD operations for RightSignature documents and reusable templates'
  spec.homepage      = 'https://github.com/equitymultiple/rs4'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/equitymultiple/rs4'
  spec.metadata['changelog_uri'] = 'https://github.com/equitymultiple/rs4/commits/master'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
