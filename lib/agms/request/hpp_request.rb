module Agms
  class HPPRequest < Request
    # A class representing AGMS Transaction Request objects.

    alias AgmsAutoValidate autoValidate

    def initialize(op)
      super(op)
      @fields = {
          :TransactionType => {:setting => '', :value => ''},
          :Amount => {:setting => '', :value => ''},
          :TipAmount => {:setting => '', :value => ''},
          :Tax => {:setting => '', :value => ''},
          :Shipping => {:setting => '', :value => ''},
          :OrderDescription => {:setting => '', :value => ''},
          :OrderID => {:setting => '', :value => ''},
          :ClerkID => {:setting => '', :value => ''},
          :PONumber => {:setting => '', :value => ''},
          :RetURL => {:setting => '', :value => ''},
          :ACHEnabled => {:setting => '', :value => ''},
          :SAFE_ID => {:setting => '', :value => ''},
          :Donation => {:setting => '', :value => ''},
          :UsageCount => {:setting => '', :value => ''},
          :Internal => {:setting => '', :value => ''},
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
          :ShippingPhone => {:setting => '', :value => ''},
          :ShippingFax => {:setting => '', :value => ''},
          :ProcessorID => {:setting => '', :value => ''},
          :TransactionID => {:setting => '', :value => ''},
          :Tracking_Number => {:setting => '', :value => ''},
          :Shipping_Carrier => {:setting => '', :value => ''},
          :IPAddress => {:setting => '', :value => ''},
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
          :HPPFormat => {:setting => '', :value => ''},
          :StartDate => {:setting => '', :value => ''},
          :EndDate => {:setting => '', :value => ''},
          :StartTime => {:setting => '', :value => ''},
          :EndTime => {:setting => '', :value => ''},
          :SuppressAutoSAFE => {:setting => '', :value => ''}
      }

      @optionable = %w('FirstName', 'LastName', 'Company', 'Address1', 'Address2',
            'City', 'State', 'Zip', 'Country', 'Phone', 'Fax',
            'EMail', 'Website', 'Tax', 'Shipping', 'OrderID',
            'PONumber', 'ShippingFirstName', 'ShippingLastName', 'ShippingCompany', 'ShippingAddress1',
            'ShippingAddress2', 'ShippingCity', 'ShippingState', 'ShippingZip', 'ShippingCountry',
            'ShippingEmail', 'ShippingPhone', 'ShippingFax', 'ShippingTrackingNumber', 'ShippingCarrier',
            'Custom_Field_1', 'Custom_Field_2', 'Custom_Field_3', 'Custom_Field_4', 'Custom_Field_5',
            'Custom_Field_6', 'Custom_Field_7', 'Custom_Field_8', 'Custom_Field_9', 'Custom_Field_10')

      @numeric = %w(Amount Tax Shipping ProcessorID TransactionID CheckABA CheckAccount CCNumber CCExpDate)

      @enums = {
          :TransactionType => %w(sale auth safe\ only capture void refund update adjustment),
          :Shipping_Carrier => %w(ups fedex dhl usps UPS Fedex DHL USPS),
          :HPPFormat => %w(1 2)
      }
      @boolean = %w(Donation AutoSAFE SuppressAutoSAFE)

      @date = %w(StartDate EndDate)

      @digit_2 = %w(State ShippingState)

      @amount = %w(Amount TipAmount Tax Shipping)

      @required = %w(TransactionType)

      # Override mapping with api-specific field maps
      @mapping[:shipping_tracking_number] = :Tracking_Number
      @mapping[:shipping_carrier] = :Shipping_Carrier

    end

    def validate
      @required = Array.new

      # All sales and auth require an amount unless donation
      if ( ( @fields[:Donation][:value] != '' or
            @fields[:Donation][:value] != false ) and
          (@fields[:TransactionType][:value] == 'sale' or
            @fields[:TransactionType][:value] == 'auth') )
        @required.push(:Amount)
      end

      error_array = AgmsAutoValidate();

      errors = error_array['errors'];
      messages = error_array['messages'];

      # ExpDate MMYY
      if (  @fields.has_key?(:CCExpDate) and
          @fields[:CCExpDate][:value] != '' and
          ( @fields[:CCExpDate][:value].length != 4 or
              not /(0[1-9]|1[0-2])([0-9][0-9])/.match(@fields[:CCExpDate][:value]) )  )
        errors += 1
        messages.push('CCExpDate (credit card expiration date) must be MMYY.')
      end

      # CCNumber length
      if (  @fields.has_key?(:CCNumber) and
          @fields[:CCNumber][:value] != ''  and
          @fields[:CCNumber][:value].length != 16 and
          @fields[:CCNumber][:value].length != 15 )
        errors += 1
        messages.push('CCNumber (credit card number) must be 15-16 digits long.')
      end

      # ABA length
      if  ( @fields.has_key?(:CheckABA) and
          @fields[:CheckABA][:value] != '' and
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
      fields =  getFieldArray
      if fields.has_key?(:AutoSAFE)
        if fields[:AutoSAFE] == true
          fields[:AutoSAFE] = 1
        else
          fields[:AutoSAFE] = 0
        end
      end
      if fields.has_key?(:SuppressAutoSAFE)
        if fields[:SuppressAutoSAFE] == true
          fields[:SuppressAutoSAFE] = 1
        else
          fields[:SuppressAutoSAFE] = 0
        end
      end
      return fields
    end

    def getParams(request)
      return {:objparameters => request}
    end
  end
end