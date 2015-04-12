module Agms

    class Agms
        # A class representing base AGMS objects.

        # Version data
        MAJOR = 0
        MINOR = 1
        TINY = 3

        API = 3

        def self.getLibraryVersion()
          return Agms::MAJOR.to_s + '.' + Agms::MINOR.to_s + '.' + Agms::TINY.to_s
        end

        def self.getAPIVersion()
          return Agms::API.to_s
        end

        def self.whatCardType(truncated, card_format='name')
          card_abb = {
              '3' => 'AX',
              '4' => 'VX',
              '5' => 'MC',
              '6' => 'DS',
          }

          card_name = {
              '3' => 'American Express',
              '4' => 'Visa',
              '5' => 'Mastercard',
              '6' => 'Discover',
          }

          first_digit = truncated[0]

          if card_format == 'abbreviation'
            begin
              return card_abb[first_digit]
            rescue
              return 'Unknown'
            end
          else
            begin
              return card_name[first_digit]
            rescue
              return 'Unknown'
            end
          end

        end

        def initialize(username=nil, password=nil, account=nil, api_key=nil)
            if username and password
                @username = username
                @password = password
                @account = account
                @api_key = api_key
            else
                @username = Configuration.gateway_username
                @password = Configuration.gateway_password
                @account = Configuration.gateway_account
                @api_key = Configuration.gateway_api_key
            end
            @op = nil
            @api_url = nil
            @request = nil
            @response = nil
        end

        def doConnect(request_method, response_object)
            # Get requestObject class name
            requestClass = Object.const_get('Agms').const_get(@requestObject)
            if @request.instance_of?(requestClass.class)
                raise RequestValidationError('No request has been created, please define request parameters.')
            else
                connect = Connect.new(Configuration.instantiate())
                request_body = @request.get(@username, @password, @account, @api_key)
                request_body = @request.getParams(request_body)
                response = connect.connect(@api_url, request_body, request_method, response_object)
                responseClass = Object.const_get('Agms').const_get(@responseObject)
                @response = responseClass.new(response, @op)
                return true
            end
        end
                
        def setParameter(field, opts)
            if not @request
                self.resetParameters()
            end
            if opts.class == Hash and opts.length > 0
                opts.each do |param, value|
                  @request.setField(field, param, value)
                end
                return true
            else
                raise InvalidParameterError('Provided options are not in valid array format.')
            end
        end

        def resetParameters()
            @request = nil
            requestClass = Object.const_get('Agms').const_get(@requestObject)
            @request = requestClass.new(@op)
        end

    end
end