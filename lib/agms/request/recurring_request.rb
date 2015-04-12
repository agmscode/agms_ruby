module Agms
  class RecurringRequest < Request
    # A class representing AGMS Recurring Request objects.

    alias AgmsAutoValidate autoValidate

    def initialize(op)
      super(op)
      @fields1 = {
          :RecurringID => {:setting => '', :value => ''},
          :MerchantID => {:setting => '', :value => ''},
          :PaymentType => {:setting => '', :value => 'creditcard'},
          :InitialAmount => {:setting => '', :value => ''},
          :RecurringAmount => {:setting => '', :value => ''},
          :CCNumber => {:setting => '', :value => ''},
          :CCExpDate => {:setting => '', :value => ''},
          :CVV => {:setting => '', :value => ''},
          :CheckName => {:setting => '', :value => ''},
          :CheckABA => {:setting => '', :value => ''},
          :CheckAccount => {:setting => '', :value => ''},
          :AccountHolderType => {:setting => '', :value => ''},
          :AccountType => {:setting => '', :value => ''},
          :SecCode => {:setting => '', :value => ''},
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
          :Website => {:setting => '', :value => ''},
          :Custom_Field_1 => {:setting => '', :value => ''},
          :Custom_Field_2 => {:setting => '', :value => ''},
          :Custom_Field_3 => {:setting => '', :value => ''},
          :Custom_Field_4 => {:setting => '', :value => ''},
          :Custom_Field_5 => {:setting => '', :value => ''},
          :Custom_Field_6 => {:setting => '', :value => ''},
          :Custom_Field_7 => {:setting => '', :value => ''},
          :Custom_Field_8 => {:setting => '', :value => ''},
          :Custom_Field_9 => {:setting => '', :value => ''},
          :Custom_Field_10 => {:setting => '', :value => ''},
          :StartDate => {:setting => '', :value => ''},
          :Frequency => {:setting => '', :value => ''},
          :Quantity => {:setting => '', :value => ''},
          :NumberOfOccurrences => {:setting => '', :value => ''},
          :EndDate => {:setting => '', :value => ''},
          :NumberOfRetries => {:setting => '', :value => ''}
      }

      @numeric = %w(InitialAmount RecurringAmount Quantity NumberOfOccurrences NumberOfRetries CCNumber CCExpDate CheckABA CheckAccount)

      @enums = {
          :PaymentType => %w(creditcard check),
          :SecCode => %w(PPD WEB TEL CCD),
          :AccountHolderType => %w(business personal),
          :AccountType => %w(checking savings),
          :Frequency => %w(days weeks months)
      }

      @date = %w(StartDate EndDate)

      @digit_2 = %w(State)

      @amount = %w(Amount TipAmount Tax Shipping)

      if @op == 'RecurringAdd'
        @fields = @fields1
      else
        raise InvalidRequestError, "Invalid op #{@op} in Request."
      end

    end

    def validate
      @required = Array.new

      if @fields[:Frequency][:value] == ''
        @required.push(:Frequency)
      end

      # If no transaction type, require a Safe Action
      if @fields[:NumberOfRetries][:value] == ''
        @required.push(:NumberOfRetries)
      end

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

    def getParams(request)
      return {:vRecurringParams => request}
    end
  end
end