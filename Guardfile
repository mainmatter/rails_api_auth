group :red_green_refactor do
  guard :rspec, cmd: 'bundle exec rspec' do
    require 'guard/rspec/dsl'

    dsl = Guard::RSpec::Dsl.new(self)

    rspec = dsl.rspec
    watch(rspec.spec_helper)  { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)

    rails = dsl.rails
    dsl.watch_spec_files_for(rails.app_files)

    watch(rails.controllers) do |m|
      [
        rspec.spec.("routing/#{m[1]}_routing"),
        rspec.spec.("controllers/#{m[1]}_controller"),
        rspec.spec.("requests/#{m[1]}")
      ]
    end

    watch(rails.spec_helper)     { rspec.spec_dir }
    watch(rails.routes)          { "#{rspec.spec_dir}/routing" }
    watch(rails.app_controller)  { "#{rspec.spec_dir}/controllers" }
    watch(rails.services)        { "#{rspec.spec_dir}/services" }
  end

  guard :rubocop, all_on_start: true do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end

guard :bundler do
  require 'guard/bundler'
  require 'guard/bundler/verify'
  helper = Guard::Bundler::Verify.new

  files = ['Gemfile']
  files += Dir['*.gemspec'] if files.any? { |f| helper.uses_gemspec?(f) }

  files.each { |file| watch(helper.real_path(file)) }
  watch(/^.+\.gemspec/)
end
