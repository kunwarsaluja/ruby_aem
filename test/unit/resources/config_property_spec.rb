require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/config_property'

describe 'ConfigProperty' do
  before do
    @mock_client = double('mock_client')
  end

  after do
  end

  describe 'test create' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::ConfigProperty,
        'create',
        { :name => 'someproperty',
          :type => 'Boolean',
          :value => 'true',
          :node_name => 'somenode',
          :run_mode => 'author',
          :someproperty => 'true',
          :someproperty_type_hint => 'Boolean' })
      config_property = RubyAem::Resources::ConfigProperty.new(@mock_client, 'someproperty', 'Boolean', 'true')
      config_property.create('author', 'somenode')
    end

  end

end