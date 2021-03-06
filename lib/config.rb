require 'yaml'
require 'ostruct'

class Config
  BASE_PATH       = './config'
  CFG_FILE_NAME   = 'cfg.yml'.freeze
  TOKEN_FILE_NAME = 'token'.freeze

  ENVIRONMENT_VARIABLE_NAME = "RACK_ENV".freeze
  DEFAULT_ENVIRONMENT       = "development".freeze

  attr_reader :config, :instance_id
  attr_accessor :token

  def initialize
    read_token
    read_config
    retrieve_id
  end

  def dump_token
    File.open(token_file_name, 'w') { |f| f.write(token) }
  end

  def env
    ENV[ENVIRONMENT_VARIABLE_NAME] ? ENV[ENVIRONMENT_VARIABLE_NAME] : DEFAULT_ENVIRONMENT
  end

  protected

  def read_token
    path = token_file_name
    return unless File.file?(path)

    @token = File.open(path, 'r') { |f| f.read }.strip
  end

  def read_config
    path = File.join(BASE_PATH, CFG_FILE_NAME)
    raise 'No config provided' unless File.file?(path)

    @config = OpenStruct.new YAML.load_file(path)
  end

  def retrieve_id
    @instance_id =
      if env != 'production'
        'unagi'
      else
        %x{ curl http://169.254.169.254/latest/meta-data/instance-id }
      end
  end

  def token_file_name
    File.join(BASE_PATH, TOKEN_FILE_NAME)
  end
end
