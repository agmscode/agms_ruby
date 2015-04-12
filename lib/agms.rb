# Add current directory in library load path
$:.unshift(File.expand_path(File.dirname(__FILE__))) unless
    $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'net/http'
require 'net/https'
require 'openssl'

require 'nokogiri'


require 'agms/version'

require 'agms/configuration'
require 'agms/agms'

require 'agms/transaction'
require 'agms/safe'
require 'agms/report'
require 'agms/recurring'
require 'agms/invoicing'
require 'agms/hpp'

require 'agms/error/agms_error'
require 'agms/error/authentication_error'
require 'agms/error/authorization_error'
require 'agms/error/client_error_error'
require 'agms/error/configuation_error'
require 'agms/error/down_for_maintenance_error'
require 'agms/error/forged_query_String_error'
require 'agms/error/invalid_parameter_error'
require 'agms/error/invalid_request_error'
require 'agms/error/invalid_signature_error'
require 'agms/error/not_found_error'
require 'agms/error/request_validation_error'
require 'agms/error/response_error'
require 'agms/error/server_error_error'
require 'agms/error/ssl_certificate_error'
require 'agms/error/unexpected_error'
require 'agms/error/upgrade_required_error'

require 'agms/request/request'
require 'agms/request/transaction_request'
require 'agms/request/safe_request'
require 'agms/request/report_request'
require 'agms/request/recurring_request'
require 'agms/request/invoicing_request'
require 'agms/request/hpp_request'

require 'agms/response/response'
require 'agms/response/transaction_response'
require 'agms/response/safe_response'
require 'agms/response/report_response'
require 'agms/response/recurring_response'
require 'agms/response/invoicing_response'
require 'agms/response/hpp_response'

require 'agms/connect'

