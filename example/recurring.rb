require 'agms'

Agms::Configuration.init('init.yml')
Agms::Configuration.verbose = true
recur = Agms::Recurring.new

params = {
    :recurring_amount => {:value => '20.00'},
    :cc_number => { :value => '4111111111111111'},
    :cc_exp_date => {:value => '0520'},
    :cc_cvv => {:valuRe => '123'},
    :first_name => {:value => 'Test'},
    :last_name => {:value => 'Recurring'},
    :start_date => {:value => '2014-11-09'},
    :end_date => {:value => '2018-11-09'},
    :frequency => {:value => 'months'},
    :number_of_retries => {:value => '2'},
    :email => {:value => 'maanas@agms.com'}
}

result = recur.add(params)

print result