module Agms
  class SAFERequest < Request
    # A class representing AGMS SAFE Request objects.

    alias AgmsAutoValidate autoValidate

    def initialize(op)
      super(op)
      @fields = {
          :TransactionType => {:setting => '', :value => ''},
          :PaymentType => {:setting => '', :value => 'creditcard'},
          :Amount => {:setting => '', :value => ''}, # Required for sale or auth
          :Tax => {:setting => '', :value => ''},
          :Shipping => {:setting => '', :value => ''},
          :OrderDescription => {:setting => '', :value => ''},
          :OrderID => {:setting => '', :value => ''},
          :PONumber => {:setting => '', :value => ''},
          :CCNumber => {:setting => '', :value => ''}, # Required for sale and auth if payment type = creditcard without safe id
          :CCExpDate => {:setting => '', :value => ''}, # Required for sale and auth if payment type = creditcard without safe id
          :CVV => {:setting => '', :value => ''},
          :CheckName => {:setting => '', :value => ''}, # Required for sale and auth if payment type = check without safe id
          :CheckABA => {:setting => '', :value => ''}, # Required for sale and auth if payment type = check without safe id
          :CheckAccount => {:setting => '', :value => ''}, # Required for sale and auth if payment type = check without safe id
          :AccountHolderType => {:setting => '', :value => ''}, # Required for sale and auth if payment type = check without safe id
          :AccountType => {:setting => '', :value => ''}, # Required for sale and auth if payment type = check without safe id
          :SecCode => {:setting => '', :value => ''}, # Required for sale and auth if payment type = check without safe id
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
          :ShippingFirstName => {:setting => '', :value => ''},
          :ShippingLastName => {:setting => '', :value => ''},
          :ShippingCompany => {:setting => '', :value => ''},
          :ShippingAddress1 => {:setting => '', :value => ''},
          :ShippingAddress2 => {:setting => '', :value => ''},
          :ShippingCity => {:setting => '', :value => ''},
          :ShippingState => {:setting => '', :value => ''},
          :ShippingZip => {:setting => '', :value => ''},
          :ShippingCountry => {:setting => '', :value => ''},
          :ShippingEmail => {:setting => '', :value => ''},
          :ProcessorID => {:setting => '', :value => ''},
          :TransactionID => {:setting => '', :value => ''},
          :Tracking_Number => {:setting => '', :value => ''},
          :Shipping_Carrier => {:setting => '', :value => ''},
          :IPAddress => {:setting => '', :value => ''},
          :Track1 => {:setting => '', :value => ''},
          :Track2 => {:setting => '', :value => ''},
          :Track3 => {:setting => '', :value => ''},
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
          :SAFE_Action => {:setting => '', :value => ''},
          :SAFE_ID => {:setting => '', :value => ''},
          :ReceiptType => {:setting => '', :value => ''},
          :CCNumber2 => {:setting => '', :value => ''},
          :Clerk_ID => {:setting => '', :value => ''},
          :Billing_Code => {:setting => '', :value => ''},
          :InvoiceID => {:setting => '', :value => ''},
          :BatchID => {:setting => '', :value => ''},
          :MagData => {:setting => '', :value => ''},
          :MagHardware => {:setting => '', :value => ''},
          :TipAmount => {:setting => '', :value => ''}, # Required for Adjustment
          
      }

      @numeric = %w(Amount Tax Shipping ProcessorID TransactionID CheckABA CheckAccount CCNumber CCExpDate)

      @enums = {
          :TransactionType => %w(sale auth safe\ only capture void refund update adjustment),
          :SAFE_Action => %w(add_safe update_safe delete_safe),
          :PaymentType => %w(creditcard check),
          :SecCode => %w(PPD WEB TEL CCD),
          :AccountHolderType => %w(business personal),
          :AccountType => %w(checking savings),
          :MagHardware => %w(MAGTEK IDTECH),
          :Shipping_Carrier => %w(ups fedex dhl usps UPS Fedex DHL USPS),
      }

      @date = %w(StartDate EndDate)

      @state = %w(State ShippingState)

      @amount = %w(Amount Tax Shipping TipAmount)

      # Override mapping with api-specific field maps
      @mapping[:shipping_tracking_number] = :Tracking_Number
      @mapping[:shipping_carrier] = :Shipping_Carrier

    end

    def validate
      @required = Array.new

      # If no transaction type, require a Safe Action
      if @fields[:TransactionType][:value] == ''
        @required.push(:SAFE_Action)
      end

      # All sales and auths require an amount
      if (@fields[:TransactionType][:value] == 'sale' or
          @fields[:TransactionType][:value] == 'auth')
        @required.push(:Amount)
      end

      # Captures, refunds, voids, updates, adjustments need a Transaction ID
      if (@fields[:TransactionType][:value] == 'capture' or
          @fields[:TransactionType][:value] == 'refund' or
          @fields[:TransactionType][:value] == 'void' or
          @fields[:TransactionType][:value] == 'adjustment')
        @required.push(:TransactionID)
      end

      # Require TipAmount for Tip Adjustment transactions
      if @fields[:TransactionType][:value] == 'adjustment'
        @required.push(:TipAmount)
      end

      # All safe updates and deletes require a safe id
      if (@fields[:SAFE_Action][:value] == 'update' or
          @fields[:SAFE_Action][:value] == 'delete')
        @required.push(:SAFE_ID)
      end


      if @fields[:PaymentType][:value] == 'check'
        # Cheque transaction
        if @fields[:SAFE_ID][:value] == ''
          # If no Safe ID we need all the check info
          @required.push(:CheckName)
          @required.push(:CheckABA)
          @required.push(:CheckAccount)
          if (@fields[:TransactionType][:value] == 'sale' or
              @fields[:TransactionType][:value] == 'auth')
            @required.push(:SecCode)
          end
        end
      else
        # Credit card transaction
        # If no SAFE ID and its a sale or auth
        if (@fields[:SAFE_ID][:value] == '' and
            (@fields[:TransactionType][:value] == 'sale' or
                @fields[:TransactionType][:value] == 'auth'))
          # If no Safe ID we need the card info
          # If no MagData then we need keyed info
          if @fields[:MagData][:value] == ''
            @required.push(:CCNumber)
            @required.push(:CCExpDate)
          else
            @required.push(:MagHardware)
          end
        end
      end

      error_array = AgmsAutoValidate();

      errors = error_array['errors'];
      messages = error_array['messages'];

      # ExpDate MMYY
      if (@fields[:CCExpDate][:value] != '' and
          (@fields[:CCExpDate][:value].length != 4 or
              not /(0[1-9]|1[0-2])([0-9][0-9])/.match(@fields[:CCExpDate][:value])))
        errors += 1
        messages.push('CCExpDate (credit card expiration date) must be MMYY.')
      end

      # CCNumber length
      if (@fields[:CCNumber][:value] != '' and
          @fields[:CCNumber][:value].length != 16 and
          @fields[:CCNumber][:value].length != 15)
        errors += 1
        messages.push('CCNumber (credit card number) must be 15-16 digits long.')
      end

      # ABA length
      if (@fields[:CheckABA][:value] != '' and
          @fields[:CheckABA][:value].length != 9)
        errors += 1
        messages.push('CheckABA (routing number) must be 9 digits long.')
      end

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