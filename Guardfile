guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/support/.+\.rb}) { 'spec' }
  watch(%r{^lib/(.+)\.rb$})       { 'spec/acceptance' }
  watch('spec/spec_helper.rb')    { 'spec' }

  # watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
end

