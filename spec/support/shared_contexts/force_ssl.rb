shared_context 'with force_ssl configured' do
  around do |example|
    default_force_ssl = RailsApiAuth.force_ssl
    RailsApiAuth.force_ssl = force_ssl
    example.run
    RailsApiAuth.force_ssl = default_force_ssl
  end
end
