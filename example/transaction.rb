require 'agms'

Agms::Configuration.init('init.yml')

trans = Agms::Transaction.new

params = {
    :transaction_type => { :value => 'sale'},
    :amount => { :value => '100.00'},
    :cc_number => { :value => '4111111111111111'},
    :cc_exp_date => { :value => '0520'},
    :cc_cvv => { :value => '123'}
}

result = trans.process(params)

print result