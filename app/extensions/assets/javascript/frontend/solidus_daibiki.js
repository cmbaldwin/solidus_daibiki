document.addEventListener('DOMContentLoaded', function () {
  const daibikiDesc = document.getElementById('daibiki-description');
  if (daibikiDesc) {
    const usersOnly = daibikiDesc.dataset.usersOnly === 'true';
    const noUser = usersOnly ? daibikiDesc.dataset.hasUser === '0' : false;
    const maxAmount = daibikiDesc.dataset.totalMax;
    const orderTotal = daibikiDesc.dataset.orderTotal;
    if (parseInt(orderTotal) > parseInt(maxAmount) || noUser) {
      const daibikiOption = document.getElementById(`order_payments_attributes__payment_method_id_${daibikiDesc.dataset.paymentId}`);
      daibikiOption.disabled = true;
      daibikiOption.classList.add('opacity-50', 'cursor-not-allowed', 'bg-gray-400')
      daibikiOption.parentElement.classList.add('text-gray-400');
      const span = document.createElement('span');
      const warningMessage = (parseInt(orderTotal) > parseInt(maxAmount)) ? daibikiDesc.dataset.totalExcessWarning : daibikiDesc.dataset.noUserWarning;
      span.innerText = warningMessage;
      daibikiOption.parentElement.append(span);
    }
  }
});