$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'freshbooks'

require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!(Minitest::Reporters::DefaultReporter.new(color: true))

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

def client_options
  {
    api_url: load_env['BASE_URL'],
    token: load_env['TOKEN']
  }
end

def fixtures_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
  File.read(fixtures_path + '/' + file)
end

def api_fixture(file)
  fixture('api' + '/' + file)
end

def remove_xml_whitespace(xml)
  xml.gsub(/>\s*</, "><").strip
end

def load_env
  require 'dotenv'
  Dotenv.load
end

def is_instance(meth, inst)
  describe "##{meth}" do
    it "should return a Freshbooks::API::#{inst} instance" do
      assert_instance_of eval("Freshbooks::API::#{inst}"), @client.send(meth.to_sym)
    end
  end
end
