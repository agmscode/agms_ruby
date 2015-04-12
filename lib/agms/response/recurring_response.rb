module Agms
  class RecurringResponse < Response
    # A class representing AGMS Recurring Response objects.

    def initialize(response, op)
      @response = nil
      @op = op

      response = response['soap:Envelope']['soap:Body'][op + 'Response'][op + 'Result']

      if @op == 'RecurringAdd' or @op == 'RecurringDelete' or @op == 'RecurringUpdate'
        @mapping = {
            :RESULT => 'result',
            :MSG => 'message',
            :RecurringID => 'recurring_id',
        }
      elsif @op == 'RetrieveRecurringID'
        @mapping = {
            :RecurringID => 'recurring_id'
        }
      else
        raise InvalidRequestError, 'Invalid op in Response.'
      end
      @response = response
    end

  end
end