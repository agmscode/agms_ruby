module Agms
  class HPPRequest < Request
    # Builds all the fields to be used in an HPP generation request

    alias AgmsAutoValidate autoValidate

    def initialize(op)
      super(op)
      @fields = {
          :HPPFormat => {:setting => '', :value => ''},
          :Amount => {:setting => '', :value => ''},
          :OrderDescription => {:setting => '', :value => ''},
          :RetURL => {:setting => '', :value => ''},
          :ACHEnabled => {:setting => '', :value => ''},
          :SAFE_ID => {:setting => '', :value => ''},
          :TransactionType => {:setting => '', :value => ''},
          :AutoSAFE => {:setting => '', :value => ''},
          :SuppressAutoSAFE => {:setting => '', :value => ''},
          :ProcessorID => {:setting => '', :value => ''},
          :Donation => {:setting => '', :value => ''},
          :UsageCount => {:setting => '', :value => ''},
          :StartDate => {:setting => '', :value => ''},
          :EndDate => {:setting => '', :value => ''},
          :StartTime => {:setting => '', :value => ''},
          :EndTime => {:setting => '', :value => ''},
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
          :Tax => {:setting => '', :value => ''},
          :Shipping => {:setting => '', :value => ''},
          :OrderID => {:setting => '', :value => ''},
          :PONumber => {:setting => '', :value => ''},
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
          :ShippingTrackingNumber => {:setting => '', :value => ''},
          :ShippingCarrier => {:setting => '', :value => ''},
          :Custom_Field_1 => {:setting => '', :value => ''},
          :Custom_Field_2 => {:setting => '', :value => ''},
          :Custom_Field_3 => {:setting => '', :value => ''},
          :Custom_Field_4 => {:setting => '', :value => ''},
          :Custom_Field_5 => {:setting => '', :value => ''},
          :Custom_Field_6 => {:setting => '', :value => ''},
          :Custom_Field_7 => {:setting => '', :value => ''},
          :Custom_Field_8 => {:setting => '', :value => ''},
          :Custom_Field_9 => {:setting => '', :value => ''},
          :Custom_Field_10 => {:setting => '', :value => ''}          
      }

      @optionable = %w('FirstName', 'LastName', 'Company', 'Address1', 'Address2',
            'City', 'State', 'Zip', 'Country', 'Phone', 'Fax',
            'EMail', 'Website', 'Tax', 'Shipping', 'OrderID',
            'PONumber', 'ShippingFirstName', 'ShippingLastName', 'ShippingCompany', 'ShippingAddress1',
            'ShippingAddress2', 'ShippingCity', 'ShippingState', 'ShippingZip', 'ShippingCountry',
            'ShippingEmail', 'ShippingPhone', 'ShippingFax', 'ShippingTrackingNumber', 'ShippingCarrier',
            'Custom_Field_1', 'Custom_Field_2', 'Custom_Field_3', 'Custom_Field_4', 'Custom_Field_5',
            'Custom_Field_6', 'Custom_Field_7', 'Custom_Field_8', 'Custom_Field_9', 'Custom_Field_10')

      @numeric = %w(Amount Tax Shipping ProcessorID HPPFormat)

      @enums = {
          :TransactionType => %w(sale auth safe\ only),
          :Shipping_Carrier => %w(ups fedex dhl usps UPS Fedex DHL USPS),
          :HPPFormat => %w(1 2)
      }
      @boolean = %w(Donation AutoSAFE SuppressAutoSAFE)

      @date = %w(StartDate EndDate)

      @time = %w(StartTime EndTime)

      @state = %w(State ShippingState)

      @amount = %w(Amount Shipping)

      @required = %w(TransactionType)

    end

    def validate
      @required = Array.new

      # All sales and auth require an amount unless donation
      if ((@fields[:Donation][:value] != '' or
          @fields[:Donation][:value] != false) and
          (@fields[:TransactionType][:value] == 'sale' or
              @fields[:TransactionType][:value] == 'auth'))
        @required.push(:Amount)
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
      fields = getFieldArray
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

  end
end