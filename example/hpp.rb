require './lib/agms'

Agms::Configuration.init('init.yml')

hpp = Agms::HPP.new

params = {
    :transaction_type => { :value => 'sale'},
    :amount => { :value => '20.00'},
    :first_name => {  :setting => 'required'},
    :last_name => { :setting => 'required'},
    :zip => { :setting => 'required'},
    :email => { :setting => 'required'},
    :hpp_format => { :value => '1'}
}

result = hpp.generate(params)
print result