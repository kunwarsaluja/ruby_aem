require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/handlers/xml'

describe 'XML Handler' do
  before do
  end

  after do
  end

  describe 'test xml_package_list' do
    it 'should return success result when data payload contains 200 ok element' do
      data =
        '<crx version="1.4.1" user="admin" workspace="crx.default">' \
        '  <request>' \
        '    <param name="cmd" value="ls"/>' \
        '  </request>' \
        '  <response>' \
        '    <data>' \
        '      <packages>' \
        '        <package>' \
        '          <group>Adobe/granite</group>' \
        '          <name>com.adobe.granite.httpcache.content</name>' \
        '          <version>1.0.2</version>' \
        '          <downloadName>com.adobe.granite.httpcache.content-1.0.2.zip</downloadName>' \
        '          <size>13323</size>' \
        '          <created>Tue, 25 Feb 2014 21:40:56 +1100</created>' \
        '          <createdBy>Adobe</createdBy>' \
        '          <lastModified></lastModified>' \
        '          <lastModifiedBy>null</lastModifiedBy>' \
        '          <lastUnpacked>Sat, 3 Sep 2016 08:47:07 +1000</lastUnpacked>' \
        '          <lastUnpackedBy>admin</lastUnpackedBy>' \
        '        </package>' \
        '      </packages>' \
        '    </data>' \
        '    <status code="200">ok</status>' \
        '  </response>' \
        '</crx>'
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Package list retrieved successfully' }
      call_params = {}

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.xml_package_list(response, response_spec, call_params)
      expect(result.message).to eq('Package list retrieved successfully')
      expect(result.response).to eq(response)
    end

    it 'should return success result when data payload does not contain 200 ok element' do
      data =
        '<crx version="1.4.1" user="admin" workspace="crx.default">' \
        '  <request>' \
        '    <param name="cmd" value="ls"/>' \
        '  </request>' \
        '  <response>' \
        '    <status code="500">error</status>' \
        '  </response>' \
        '</crx>'
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Package list retrieved successfully' }
      call_params = {}

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.xml_package_list(response, response_spec, call_params)
      expect(result.message).to eq('Unable to retrieve package list, getting status code 500 and status text error')
      expect(result.response).to be(response)
    end
  end
end
