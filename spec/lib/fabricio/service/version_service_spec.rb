require 'rspec'
require 'webmock/rspec'
require 'fabricio/services/version_service'
require 'fabricio/authorization/memory_session_storage'

describe 'VersionService' do

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
    @service = Fabricio::Service::VersionService.new(param_storage, client)
  end

  it 'should fetch all versions' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/version_service_all_stub_response.txt')
    stub_request(:get, /versions/).to_return(:body => response_file, :status => 200)

    result = @service.all
    expect(result).not_to be_nil
  end

  it 'should get top versions' do
    response_file = File.new(Dir.getwd + '/spec/lib/fabricio/service/version_service_top_stub_response.txt')
    stub_request(:get, /top_builds/).to_return(:body => response_file, :status => 200)

    result = @service.top
    expect(result).not_to be_nil
  end

end
