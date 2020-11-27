function changeTab() {
    var newActiveTabID = $('input[name="payment-selection"]:checked').val();
    $('.paymentSelectionTab').removeClass('active');
    $('#tab-' + newActiveTabID).addClass('active');
}