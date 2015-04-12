module Agms
	class Connect
		
		def self.is_exception_status(status)
			if [200, 201, 422].include?(status)
        return true
      else
      	return false
      end
    end

		def self.raise_exception_for_status(status, message=nil)
      case status.to_i
        when 401
          raise AuthenticationError
        when 403
          raise AuthorizationError, message
        when 404
          raise NotFoundError
        when 426
          raise UpgradeRequiredError
        when 500
          raise ServerError
        when 503
          raise DownForMaintenanceError
        else
          raise UnexpectedError, "Unexpected HTTP_RESPONSE #{status.to_i}"
      end
    end

    def initialize(config)
      @config = config
    end

    def connect(url, request, request_method, response_object)
    	headers = _buildHeaders(request_method)
      request_body = _buildRequest(request, request_method)
      response_body = post(url, headers, request_body)
      return _parseResponse(response_body, request_method)
		end

		def post(url, headers = nil, body = nil)
      return _http_do(Net::HTTP::Post, url, headers, body)
    end

		def delete(url, headers = nil, body = nil)
			return _http_do(Net::HTTP::Delete, url, headers, body)
    end

    def get(url, headers = nil, body = nil)
    	return _http_do Net::HTTP::Get, url, headers, body
    end

    def put(url, headers = nil, body = nil)
    	return _http_do Net::HTTP::Put, url, headers, body
    end

    def _http_do(http_verb, url, headers = nil, body = nil)
      connection = Net::HTTP.new(Configuration.server, Configuration.port)
      connection.open_timeout = 60
      connection.read_timeout = 60
      
     	connection.use_ssl = true
      connection.verify_mode = OpenSSL::SSL::VERIFY_PEER
      
      # connection.ca_file = @config.ca_file
      connection.verify_callback = proc { |preverify_ok, ssl_context| _verify_ssl_certificate(preverify_ok, ssl_context) }

      # Debug connection
      if Configuration.verbose
        connection.set_debug_output($stdout)
      end

      connection.start do |http|
      	request = http_verb.new(url)
        
      	if headers
      		headers.each do |key, value|
      			request[key] = value
      		end
        end
        if body
          request.body = body
        end

        response = http.request(request)
        if response.code.to_i == 200 || response.code.to_i == 201 || response.code.to_i == 422
        	return response.body
      	else
	        Connect.raise_exception_for_status(response.code)
	      end
      end
    rescue OpenSSL::SSL::SSLError
      raise SSLCertificateError
    end

		# Build Header
		def _buildHeaders(request_method)
			return {
	            'Accept' => 'application/xml',
	            'Content-type' => 'text/xml; charset=utf-8',
	            'User-Agent' => '(Agms Ruby ' + Agms.getLibraryVersion() + ')',
	            'X-ApiVersion' => Agms.getAPIVersion(),
	            'SOAPAction' => 'https://gateway.agms.com/roxapi/' + request_method
	        }
		end

		# Build Request
		def _buildRequest(request, request_method)
			header = '<soap:Envelope 
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
				xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
				xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
            	<soap:Body>'
            
        	header_line = '<' + request_method + ' xmlns="https://gateway.agms.com/roxapi/">'
        	body = _hashToXml(request)
          footer_line = '</' + request_method + '>'
        	footer = '</soap:Body></soap:Envelope>'
        	return header + header_line + body + footer_line + footer		
		end

    # Build xml from Hash
    def _hashToXml(request)
      data = ''
      request.each do |key, value|
        if value != ''
          # Open Tag
          data = data + "<#{key}>"
          # Check whether value is still a hash
          if value.class == Hash
            value = _hashToXml(value)
          end
          # Add data
          data = data + "#{value}"
          # Close Tag
          data = data + "</#{key}>"
        end
      end
      return data
    end

		def _verify_ssl_certificate(preverify_ok, ssl_context)
      if preverify_ok != true || ssl_context.error != 0
        err_msg = "SSL Verification failed -- Preverify: #{preverify_ok}, Error: #{ssl_context.error_string} (#{ssl_context.error})"
        @config.logger.error err_msg
        false
      else
        true
      end
    end

		# Parse the response received from gateway
		def _parseResponse(xml, request_method)
      # Parse the response body
      doc = Nokogiri::XML(xml)
      # Remove the namespaces
      doc.remove_namespaces!
      response = {}
      # Extract the response data from the #{request_method}Result node
      if request_method != 'ReturnHostedPaymentSetup'
        doc.xpath("//#{request_method}Result//*").each do |node|
          response[node.name] = node.children.text
        end
      else
        doc.xpath("//#{request_method}Response//*").each do |node|
          response = node.children.text
        end
      end

      return response
	  end

	    
	end
end