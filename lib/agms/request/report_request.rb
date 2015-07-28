module Agms
  class ReportRequest < Request
    # A class representing AGMS Report Request objects.

    alias AgmsAutoValidate autoValidate

    def initialize(op)
      super(op)
      @trans_fields = {
          :Amount => {:setting => '', :value => ''}, # Required for sale or auth
          :FirstName => {:setting => '', :value => ''},
          :LastName => {:setting => '', :value => ''},
          :Company => {:setting => '', :value => ''},
          :Address1 => {:setting => '', :value => ''},
          :Address2 => {:setting => '', :value => ''},
          :City => {:setting => '', :value => ''},
          :State => {:setting => '', :value => ''},
          :Zip => {:setting => '', :value => ''},
          :Country => {:setting => '', :value => ''},
          :Phone => {:setting => '', :value => ''},
          :Fax => {:setting => '', :value => ''},
          :EMail => {:setting => '', :value => ''},
          :SAFE_ID => {:setting => '', :value => ''},
          :TransactionType => {:setting => '', :value => ''},
          :PaymentType => {:setting => '', :value => 'creditcard'},
          :ProcessorID => {:setting => '', :value => ''},
          :TransactionID => {:setting => '', :value => ''},
          :CreditCardLast4 => {:setting => '', :value => ''}
      }

      @safe_fields = {
          :Active => {:setting => '', :value => ''},
          :PaymentType => {:setting => '', :value => 'creditcard'},
          :SafeID => {:setting => '', :value => ''},
          :StartDate => {:setting => '', :value => ''},
          :EndDate => {:setting => '', :value => ''},
          :FirstName => {:setting => '', :value => ''},
          :LastName => {:setting => '', :value => ''},
          :Company => {:setting => '', :value => ''},
          :EMail => {:setting => '', :value => ''},
          :Expiring30 => {:setting => '', :value => ''}
      }

      @numeric = %w(Amount ProcessorID TransactionID CreditCardLast4)

      @date = %w(StartDate EndDate)

      @state = %w(State)

      if @op == 'TransactionAPI'
        @fields = @trans_fields
        # Override mapping with api-specific field maps
        @mapping[:safe_id] = :Safe_ID
        @mapping[:gateway_username] = :GatewayUsername
      elsif @op == 'QuerySAFE'
        @fields = @safe_fields
        # Override mapping with api-specific field maps
        @mapping[:safe_id] = :SafeID
        @mapping[:gateway_username] = :GatewayUsername
        @mapping[:gateway_key] = :APIKey
      else
        raise InvalidRequestError, "Invalid op #{@op} in Request."
      end

      @needs_account = true
      @needs_key = true

    end

    def validate
      @required = []

      error_array = AgmsAutoValidate();

      errors = error_array['errors'];
      messages = error_array['messages'];

      @validate_errors = errors;
      @validate_messages = messages;

      if errors == 0
        return {'errors' => errors, 'messages' => messages}
      else
        raise RequestValidationError, "Request validation failed with #{messages.join(' ')}."
      end

    end

    def getFields
      return getFieldArray
    end

  end
end