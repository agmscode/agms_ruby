module Agms
  class SSLCertificateError < AgmsError
    def initialize(message, object)
      super(message, object)
    end
  end
end