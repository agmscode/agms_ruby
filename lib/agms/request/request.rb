module Agms
  class Request
    def initialize(op)
      @op = op
      @validateErrors = 0
      @validateMessages = nil
      @fields = nil
      @required = nil
      @numeric = nil
      @optionable = nil
      @enums = nil
      @date = nil
      @time = nil
      @boolean = nil
      @digit_2 = nil
      @amount = nil

      @needs_account = nil
      @needs_key = nil

      @mapping_alias = nil

      @mapping = {
          :gateway_username => :GatewayUserName,
          :gateway_password => :GatewayPassword,
          :gateway_account => :AccountNumber,
          :gateway_key => :TransactionAPIKey,
          :amount => :Amount,
          :description => :OrderDescription,
          :order_description => :OrderDescription,
          :return_url => :RetURL,
          :enable_ach => :ACHEnabled,
          :transaction_type => :TransactionType,
          :payment_type => :PaymentType,
          :enable_auto_add_to_safe => :AutoSAFE,
          :processing_account_id => :ProcessorID,
          :enable_donation => :Donation,
          :max_link_uses => :UsageCount,
          :cc_number => :CCNumber,
          :cc_exp_date => :CCExpDate,
          :cc_cvv => :CVV,
          :cc_track_1 => :Track1,
          :cc_track_2 => :Track2,
          :cc_track_3 => :Track3,
          :cc_encrypted_data => :MagData,
          :cc_encrypted_hardware => :MagHardware,
          :ach_name => :CheckName,
          :ach_routing_number => :CheckABA,
          :ach_account_number => :CheckAccount,
          :ach_business_or_personal => :AccountHolderType,
          :ach_checking_or_savings => :AccountType,
          :ach_sec_code => :SecCode,
          :safe_action => :SAFE_Action,
          :safe_id => :SAFE_ID,
          :first_name => :FirstName,
          :last_name => :LastName,
          :company_name => :Company,
          :company => :Company,
          :address => :Address1,
          :address_1 => :Address1,
          :address_2 => :Address2,
          :city => :City,
          :state => :State,
          :zip => :Zip,
          :country => :Country,
          :phone => :Phone,
          :fax => :Fax,
          :email => :EMail,
          :website => :Website,
          :tax_amount => :Tax,
          :shipping_amount => :Shipping,
          :tip_amount => :TipAmount,
          :order_id => :OrderID,
          :po_number => :PONumber,
          :clerk_id => :ClerkID,
          :ip_address => :IPAddress,
          :receipt_type => :ReceiptType,
          :shipping_first_name => :ShippingFirstName,
          :shipping_last_name => :ShippingLastName,
          :shipping_company_name => :ShippingCompany,
          :shipping_company => :ShippingCompany,
          :shipping_address => :ShippingAddress1,
          :shipping_address_1 => :ShippingAddress1,
          :shipping_address_2 => :ShippingAddress2,
          :shipping_city => :ShippingCity,
          :shipping_state => :ShippingState,
          :shipping_zip => :ShippingZip,
          :shipping_country => :ShippingCountry,
          :shipping_email => :ShippingEmail,
          :shipping_phone => :ShippingPhone,
          :shipping_fax => :ShippingFax,
          :shipping_tracking_number => :ShippingTrackingNumber,
          :shipping_carrier => :ShippingCarrier,
          :custom_field_1 => :Custom_Field_1,
          :custom_field_2 => :Custom_Field_2,
          :custom_field_3 => :Custom_Field_3,
          :custom_field_4 => :Custom_Field_4,
          :custom_field_5 => :Custom_Field_5,
          :custom_field_6 => :Custom_Field_6,
          :custom_field_7 => :Custom_Field_7,
          :custom_field_8 => :Custom_Field_8,
          :custom_field_9 => :Custom_Field_9,
          :custom_field_10 => :Custom_Field_10,
          :custom_field_11 => :Custom_Field_11,
          :custom_field_12 => :Custom_Field_12,
          :custom_field_13 => :Custom_Field_13,
          :custom_field_14 => :Custom_Field_14,
          :custom_field_15 => :Custom_Field_15,
          :custom_field_16 => :Custom_Field_16,
          :custom_field_17 => :Custom_Field_17,
          :custom_field_18 => :Custom_Field_18,
          :custom_field_19 => :Custom_Field_19,
          :custom_field_20 => :Custom_Field_20,
          :expiring_in_30_days => :Expiring30,
          :recurring_id => :RecurringID,
          :merchant_id => :MerchantID,
          :initial_amount => :InitialAmount,
          :recurring_amount => :RecurringAmount,
          :frequency => :Frequency,
          :quantity => :Quantity,
          :number_of_times_to_bill => :NumberOfOccurrences,
          :number_of_retries => :NumberOfRetries,
          :hpp_format => :HPPFormat,
          :cc_last_4 => :CreditCardLast4,
          :transaction_id => :TransactionID,
          :start_date => :StartDate,
          :end_date => :EndDate,
          :start_time => :StartTime,
          :end_time => :EndTime,
          :suppress_safe_option => :SupressAutoSAFE
      }

      @states = %w(AL AK AS AZ AR CA CO CT DE DC FM FL GA GU HI ID IL IN IA KS KY LA ME MH MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND MP OH OK OR PW PA PR RI SC SD TN TX UT VT VI VA WA WV WI WY AE AA AP)
    end

    def get(username, password, account, api_key)
      request_body = getFields()
      request_body[:GatewayUserName] = username
      request_body[:GatewayPassword] = password

      # Adjust for a field name variation in the Reporting API
      if @op == 'TransactionAPI' or @op == 'QuerySAFE'
        request_body.delete(:GatewayUserName)
        request_body[:GatewayUsername] = username
      end

      # Add Account # and API Key field to request when necessary for specific API
      if @needs_account
        request_body[:AccountNumber] = account
      end

      if @needs_key
        # Adjust for a field name variation in the Reporting API
        if @op == 'TransactionAPI'
          request_body[:TransactionAPIKey] = api_key
        elsif @op == 'QuerySAFE'
          request_body[:APIKey] = api_key
        end
      end

      return request_body
    end

    def setField(name, parameter, value)
      field_name = mapToField(name)
      # Fix for odd capitalization of Email
      if field_name == :Email
        field_name = :EMail
      end

      # Check that field exists
      if not @fields.has_key?(field_name)
        raise InvalidParameterError, "Invalid field name #{name}."
      end

      # Ensure that setting parameters are forced to all lowercase and are case insensitive
      if parameter == :setting
        value = value.downcase
      end

      # Check that it is a valid setting
      if (parameter == :setting and
          value != '' and
          value != 'required' and
          value != 'disabled' and
          value != 'visible' and
          value != 'excluded' and
          value != 'hidden')
        raise InvalidParameterError, "Invalid parameter #{parameter} for #{name}."
      end

      if parameter == :setting
        @fields[field_name][:setting] = value
        return true
      elsif parameter == :value
        @fields[field_name][:value] = value
        return true
      else
        raise InvalidParameterError, "Invalid parameter #{parameter} for #{name}."
      end
    end

    def getField(name)
      field_name = mapToField(name)
      return @fields[field_name]
    end

    def getValidationErrors
      return @validateErrors
    end


    def getValidationMessages
      return @validateMessages
    end

    protected
    def autoValidate
      errors = 0
      messages = Array.new

      if @required
        @required.each do |field_name|
          if @fields[field_name][:value] == ''
            errors +=1
            messages.push("Missing required field #{field_name}.")
          end
        end
      end

      # Validate enumerated types
      if @enums
        @enums.each do |field_name, valid_values|

          if @fields.has_key?(field_name) and
              @fields[field_name][:value] != '' and
              not valid_values.include? @fields[field_name][:value]
            errors += 1
            messages.push("Invalid #{field_name}, value " + @fields[field_name][:value] + ', must be one of ' + valid_values.join(' ') + '.')
          end
        end
      end

      # Validate numeric fields
      if @numeric
        @numeric.each do |field_name|
          if @fields.has_key?(field_name) and
              @fields[field_name][:value] != '' and
              not isNumber(@fields[field_name][:value])
            errors += 1
            messages.push("Field #{field_name} has value " + @fields[field_name][:value] + ' must be numeric.')
          end
        end
      end

      # Validate optionable fields
      if @optionable
        @optionable.each do |field_name|
          if (@fields.has_key?(field_name) and
              @fields[field_name][:setting] != '' and
              @fields[field_name][:setting] != :required and
              @fields[field_name][:setting] != :disabled and
              @fields[field_name][:setting] != :visible and
              @fields[field_name][:setting] != :excluded and
              @fields[field_name][:setting] != :hidden)
            errors += 1
            messages.push("Field #{field_name} has setting " + @fields[field_name][:value] + ', must be required, disabled, visible, hidden, or empty.')
          end
        end
      end

      # Validate date fields
      if @date
        @date.each do |field_name|

          if @fields.has_key?(field_name) and
              @fields[field_name][:value] != '' and
              not /[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])/.match(@fields[field_name][:value])
            errors += 1
            messages.push("Field #{field_name} has setting " + @fields[field_name][:value] + ', must be in date format YYYY-MM-DD.')
          end
        end
      end


      # Validate time fields
      if @time
        @time.each do |field_name|
          if not @fields[field_name][:value] != '' and
              not /([01][0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])/.match(@fields[field_name][:value])
            errors += 1
            messages.push("Field #{field_name} has setting " + @fields[field_name]['value'] + ', must be in 24h time format HH:MM:SS or HH:MM.')
          end
        end
      end


      # Validate boolean fields
      if @boolean
        @boolean.each do |field_name|
          if (@fields.has_key?(field_name) and
              not @fields[field_name][:value] != '' and
              not @fields[field_name][:value] != true and
              @fields[field_name][:value] != false and
              not @fields[field_name][:value] != 'TRUE' and
              @fields[field_name][:value] != 'FALSE'
          )
            errors += 1
            messages.push("Field #{field_name} has setting " + @fields[field_name][:value] + ', must be boolean TRUE or FALSE.')
          end
        end
      end

      # Validate state code fields
      if @digit_2
        @digit_2.each do |field_name|
          if @fields.has_key?(field_name) and
              @fields[field_name][:value] != '' and
              not @digit_2.has_key? @fields[field_name][:value]
            errors += 1
            messages.push("Field #{field_name} has setting " + @fields[field_name][:value] + ', must be valid 2 digit US State code.')
          end
        end
      end

      # Validate amount fields
      if @amount
        @amount.each do |field_name|
          if @fields.key?(field_name) and
              @fields[field_name][:value] != '' and
              @fields[field_name][:value] > Configuration.max_amount
            errors += 1
            messages.push("Field #{field_name} amount " + @fields[field_name][:value] + ", is above maximum allowable value of #{Configuration.max_amount}")
          end
          if @fields.key?(field_name) and
              @fields[field_name][:value] != '' and
              @fields[field_name][:value] < Configuration.min_amount
            errors += 1
            messages.push("Field #{field_name} amount " + @fields[field_name][:value] + ", is below minimum allowable value of #{Configuration.min_amount}")
          end
        end
      end

      return {'errors' => errors, 'messages' => messages}
    end


    def getFieldArray
      request = {}

      # Call validation, which ensures we've validated and done so against current data
      validate()

      if @validateErrors > 0
        raise RequestValidationError, 'Request validation failed with ' + '  '.join(@validateMessages) + '.'
      end

      @fields.each do |field_name, settings|
        if settings[:setting] == :required
          request[field_name] = ''
          request[field_name + '_Visible'] = true
          request[field_name + '_Required'] = true
          if field_name == :EMail
            request['Email_Disabled'] = false
          else
            request[field_name + '_Disabled'] = false
          end

        elsif settings[:setting] == :disabled
          request[field_name] = ''
          request[field_name + '_Visible'] = true
          request[field_name + '_Required'] =true
          if field_name == :EMail
            request['Email_Disabled'] = false
          else
            request[field_name + '_Disabled'] = false
          end

        elsif settings[:setting] == :visible
          request[field_name] = ''
          request[field_name + '_Visible'] = true
          request[field_name + '_Required'] = true
          if field_name == :EMail
            request['Email_Disabled'] = false
          else
            request[field_name + '_Disabled'] = false
          end

        elsif settings[:setting] == :hidden
          next

        elsif settings[:setting] == :excluded
          next

        else
          if @optionable and @optionable.include?(field_name)
            request[field_name + '_Visible'] = true
            request[field_name + '_Required'] = true
            if field_name == :EMail
              request['Email_Disabled'] = false
            else
              request[field_name + '_Disabled'] = false
            end
          end
        end

        if settings[:value]
          if settings[:value].upcase == 'TRUE'
            request[field_name] = true
          elsif settings[:value].upcase == 'FALSE'
            request[field_name] = false
          else
            request[field_name] = settings[:value]
          end
        end
      end
      return request
    end


    def mapToField(field_name)
      if @mapping.has_key?(field_name)
        return @mapping[field_name]
      elsif @mapping_alias and @mapping_alias.has_key?(field_name)
        return @mapping_alias[field_name]
      elsif @fields.has_key?(field_name)
        return field_name
      else
        raise InvalidParameterError, "Invalid field name #{field_name}."
      end
    end

    def mapToName(field_name)
      if @mapping.has_key?(field_name)
        return @mapping[field_name]
      elsif @mapping_alias and @mapping_alias.has_key?(field_name)
        return @mapping_alias[field_name]
      elsif @fields.has_key?(field_name)
        return field_name
      else
        raise InvalidParameterError, "Invalid field name #{field_name}."
      end
    end


    def isNumber(str)
      begin
        !!Integer(str)
      rescue ArgumentError, TypeError
        false
      end
    end

  end
end