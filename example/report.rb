require './lib/agms'

Agms::Configuration.init('init.yml')

rep = Agms::Report.new

params = {
    :start_date => { :value => '2015-01-01'},
    :end_date => { :value => '2015-03-28'}
}

result = rep.listTransactions(params)
print result

result = rep.listSAFEs(params)
print result