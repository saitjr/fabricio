require 'rspec'
require 'webmock/rspec'
require 'fabricio/services/build_service'
require 'fabricio/authorization/memory_session_storage'

describe 'BuildService' do

  before(:each) do
    storage = Fabricio::Authorization::MemorySessionStorage.new
    session = Fabricio::Authorization::Session.new({
                                                       'access_token' => '123',
                                                       'refresh_token' => '123'
                                                   })
    storage.store_session(session)
    client = Fabricio::Networking::NetworkClient.new(nil, storage)
    param_storage = Fabricio::Authorization::MemoryParamStorage.new
    param_storage.store_organization_id('1')
    param_storage.store_app_id('1')
    @service = Fabricio::Service::BuildService.new(param_storage, client)
  end

  it 'should fetch all builds' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/build_service_all_builds_stub_response.txt')
    stub_request(:get, /releases/).to_return(:body => response_file, :status => 200)

    result = @service.all
    expect(result).not_to be_nil
  end

  it 'should get build' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/build_service_get_build_stub_response.txt')
    stub_request(:get, /releases/).to_return(:body => response_file, :status => 200)

    result = @service.get('1', '1')
    expect(result).not_to be_nil
  end

end
