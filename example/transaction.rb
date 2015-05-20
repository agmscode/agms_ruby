require '../lib/agms.rb'

# Initialize the library configuration
# with the Gateway Credentials
Agms::Configuration.init('init.yml')

# Setup the API connection
trans = Agms::Transaction.new

# A minimalist example of a processed transaction
params = {
    :transaction_type => { :value => 'sale'},
    :amount => { :value => '10.00'},
    :cc_number => { :value => '4111111111111111'},
    :cc_exp_date => { :value => '0520'}
}

result = trans.process(params)
print result


# Setup the API connection
trans = Agms::Transaction.new

# A decline
params = {
    :transaction_type => { :value => 'sale'},
    :amount => { :value => '0.01'},
    :cc_number => { :value => '4111111111111111'},
    :cc_exp_date => { :value => '0520'}
}

result = trans.process(params)
print result


# Setup the API connection
trans = Agms::Transaction.new

# A FULL example of a processed transaction
params = {
    :transaction_type => { :value => 'sale'},
    :amount => { :value => '10.00'},
    :tax_amount => { :value => '2.00'},
    :shipping_amount => { :value => '3.00'},
    :order_description => { :value => 'big transaction detail test'},
    :order_id => { :value => '1AFSS224'},
    :po_number => { :value => '256645'},
    :first_name => { :value => 'Joe'},
    :last_name => { :value => 'Smith'},
    :company_name => { :value => 'Smith Enterprises'},
    :address => { :value => '125 Main St'},
    :address_2 => { :value => 'Suite C'},
    :city => { :value => 'Blaine'},
    :state => { :value => 'MN'},
    :zip => { :value => '55443'},
    :country => { :value => 'US'},
    :phone => { :value => '222-222-2222'},
    :fax => { :value => '333-333-3333'},
    :email => { :value => 'joe@smith.com'},
    :website => { :value => 'www.smith.com'},
    :shipping_first_name => { :value => 'Joe'},
    :shipping_last_name => { :value => 'Smith'},
    :shipping_company_name => { :value => 'Smith Enterprises'},
    :shipping_address => { :value => '125 Main St'},
    :shipping_address_2 => { :value => 'Suite C'},
    :shipping_city => { :value => 'Blaine'},
    :shipping_state => { :value => 'MN'},
    :shipping_zip => { :value => '55443'},
    :shipping_country => { :value => 'US'},
    :shipping_email => { :value => 'joe@smith.com'},
    :shipping_phone => { :value => '444-444-4444'},
    :shipping_fax => { :value => '555-555-5555'},
    :shipping_carrier => { :value => 'ups'},
    :ip_address => { :value => '128.101.101.101'},
    :shipping_tracking_number => { :value => '1Z223452433282822'},
    :custom_field_1 => { :value => 'custom 1'},
    :custom_field_2 => { :value => 'custom 2'},
    :custom_field_3 => { :value => 'custom 3'},
    :custom_field_4 => { :value => 'custom 4'},
    :custom_field_5 => { :value => 'custom 5'},
    :custom_field_6 => { :value => 'custom 6'},
    :custom_field_7 => { :value => 'custom 7'},
    :custom_field_8 => { :value => 'custom 8'},
    :custom_field_9 => { :value => 'custom 9'},
    :custom_field_10 => { :value => 'custom 10'},
    :cc_number => { :value => '4111111111111111'},
    :cc_exp_date => { :value => '0520'}
}

result = trans.process(params)
print result