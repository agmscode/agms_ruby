require 'yaml'
module Agms
	class Configuration
    # A class representing the configuration of AGMS Gateway
    
    # Attribute accessor for the class method
    class << self
      attr_accessor :server
      attr_accessor :port
      attr_accessor :use_unsafe_ssl
      attr_accessor :gateway_username 
      attr_accessor :gateway_password 
      attr_accessor :gateway_account 
      attr_accessor :gateway_api_key 
      attr_accessor :gateway_max_amount
      attr_accessor :gateway_min_amount
      attr_accessor :verbose
      attr_accessor :hpp_template
    end


    def self.init(init_file)
      Configuration.server = 'gateway.agms.com'
      Configuration.port = '443'
      Configuration.use_unsafe_ssl = false

      config = YAML::load_file(init_file)
      Configuration.gateway_username = config['username']
      Configuration.gateway_password = config['password']
      Configuration.gateway_account = config['account']
      Configuration.gateway_api_key = config['api_key']
      Configuration.gateway_max_amount = config['max_amount']
      Configuration.gateway_min_amount = config['min_amount']
      if config['verbose']
        Configuration.verbose = config['verbose']
      end
      if config['hpp_template']
        Configuration.hpp_template = config['hpp_template']
      end
    end

    def self.configure(gateway_username, gateway_password, gateway_account=nil, gateway_api_key=nil)
      Configuration.server = 'gateway.agms.com'
      Configuration.port = '443'
      Configuration.use_unsafe_ssl = false

      Configuration.gateway_username = gateway_username
      Configuration.gateway_password = gateway_password
      Configuration.gateway_account = gateway_account
      Configuration.gateway_api_key = gateway_api_key
    end

    def self.instantiate()
      return Configuration.new(
        Configuration.gateway_username,
        Configuration.gateway_password,
        Configuration.gateway_account,
        Configuration.gateway_api_key,
      )
    end

    def initialize(gateway_username, gateway_password, gateway_account=nil, gateway_api_key=nil)
      # TODO Add default value for max_amount and min_amount
      @@gateway_username = gateway_username
      @@gateway_password = gateway_password
      @@gateway_account = gateway_account
      @@gateway_api_key = gateway_api_key
    end

	end
end
