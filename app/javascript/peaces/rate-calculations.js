import Rails from "@rails/ujs"

import { v4 as uuidv4 } from 'uuid'

const SUBMIT='input[type="submit"]'
const INCOME_AMOUNT='#order_income_amount'
const OUTCOME_AMOUNT='#order_outcome_amount'
const REQUEST_DIRECTION='#order_request_direction'

const sendRequest = () => {
  const id = uuidv4();
  window.current_rate_calculation_id = id;
  const data = new FormData();
  const request_direction = $(REQUEST_DIRECTION).val();
  data.set('direction_rate_id', $('#order_direction_rate_id').val());
  data.set('income_amount', $(INCOME_AMOUNT).val());
  data.set('outcome_amount', $(OUTCOME_AMOUNT).val());
  data.set('request_direction', request_direction);
  data.set('id', id);

  const onSuccess = (response) => {
    if (response.id == window.current_rate_calculation_id) {
      if (request_direction == 'from_income') {
        $(OUTCOME_AMOUNT).val(response.outcome_amount).parent().clearQueue().effect('bounce', 'fast');
      } else {
        $(INCOME_AMOUNT).val(response.income_amount).parent().clearQueue().effect('bounce', 'fase');
      }
    }
  };

  Rails.ajax({
    url: '/rate_calculations',
    type: 'POST',
    accept: 'json',
    data: data,
    success: onSuccess,
    failure: (response) => {
      console.log("Failure response #{response}");
    }
  })

  return id
}

const disableOutputForm = () => {
  $(SUBMIT).attr('disabled', true)
}

const onChangeOutcome = (e) => {
  $(REQUEST_DIRECTION).val('from_outcome')
  sendRequest()
}
const onChangeIncome = (e) => {
  $(REQUEST_DIRECTION).val('from_income')
  sendRequest()
}

document.addEventListener("turbolinks:load", function() {
  // .on("change paste keyup"
  $(INCOME_AMOUNT).on('input', onChangeIncome)
  $(OUTCOME_AMOUNT).on('input', onChangeOutcome)
});
