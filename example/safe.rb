require './lib/agms'

Agms::Configuration.init('init.yml')

safe = Agms::SAFE.new

params = {
    :payment_type => { :value => 'creditcard'},
    :first_name => { :value => 'Joe'},
    :last_name => { :value => 'Smith'},
    :cc_number => { :value => '4111111111111111'},
    :cc_exp_date => { :value => '0500'},
    :cc_cvv => { :value => '123'}
}

safe_result = safe.add(params)
print safe_result