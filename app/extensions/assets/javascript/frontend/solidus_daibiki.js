document.addEventListener('DOMContentLoaded', function () {
  const daibikiDesc = document.getElementById('daibiki-description');
  if (daibikiDesc) {
    const maxAmount = daibikiDesc.dataset.totalMax;
    const warningMessage = daibikiDesc.dataset.warningMessage;
    const orderTotal = daibikiDesc.dataset.orderTotal;
    if (parseInt(orderTotal) > parseInt(maxAmount)) {
      const daibikiOption = document.getElementById(`order_payments_attributes__payment_method_id_${daibikiDesc.dataset.paymentId}`);
      daibikiOption.disabled = true;
      daibikiOption.classList.add('opacity-50', 'cursor-not-allowed', 'bg-gray-400')
      daibikiOption.parentElement.classList.add('text-muted');
      const span = document.createElement('span');
      span.innerText = warningMessage;
      daibikiOption.parentElement.append(span);
    }
  }
});