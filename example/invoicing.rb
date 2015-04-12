require './lib/agms'

Agms::Configuration.init('init.yml')
Agms::Configuration.verbose = true
recur = Agms::Invoicing.new

params = {
    :invoice_number => {:value => '12'},
    :invoice_date => { :value => '2014-11-20'},
    :bill_to_first_name => {:value => '0520'},
    :cc_cvv => {:value => '123'},
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