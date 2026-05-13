/**
 * Shopping Cart Coupon Functionality
 * Handles coupon application and discount calculation
 */

jQuery(document).ready(function ($) {
    "use strict";

    // Store discount information
    var currentDiscount = 0;
    var discountPercentage = 0;

    // Demo coupons for testing
    var validCoupons = {
        'RCB25': { percentage: 25, description: 'RCB Anniversary - 25% off' },
        'WELCOME10': { percentage: 10, description: 'Welcome Offer - 10% off' },
        'SAVE15': { percentage: 15, description: 'Save Now - 15% off' }
    };

    /**
     * Get total before discount
     */
    function getOriginalTotal() {
        var total = 0;
        $('input[name="product-price-total"]').each(function() {
            var val = parseFloat($(this).val()) || 0;
            total += val;
        });
        return total;
    }

    /**
     * Update cart totals display
     */
    function updateTotals() {
        var originalTotal = getOriginalTotal();
        var discountAmount = (originalTotal * discountPercentage) / 100;
        var finalTotal = originalTotal - discountAmount;

        // Update total display
        $('input[name="order-price-total"]').val(Math.round(finalTotal * 100) / 100);

        // Update or add discount row if discount > 0
        if (discountPercentage > 0) {
            if ($('#discount-row').length === 0) {
                // Add discount row before total
                var discountHtml = '' +
                    '<div class="row mb-3" id="discount-row">' +
                    '  <div class="col-md-6">' +
                    '    <span class="text-success" style="font-size: 1.2em">Discount (' + discountPercentage + '%)</span>' +
                    '  </div>' +
                    '  <div class="col-md-6 text-right">' +
                    '    <span class="text-success h5" id="discount-amount">-₹' + Math.round(discountAmount * 100) / 100 + '</span>' +
                    '  </div>' +
                    '</div>';
                
                $('#discount-row').length === 0 && 
                    $('input[name="order-price-total"]').closest('.row').before(discountHtml);
            } else {
                $('#discount-amount').text('-₹' + Math.round(discountAmount * 100) / 100);
            }
        }
    }

    /**
     * Apply coupon
     */
    $('#apply-coupon-btn').on('click', function() {
        var couponCode = $('#coupon').val().trim().toUpperCase();
        var statusDiv = $('#coupon-status');

        if (!couponCode) {
            statusDiv.html('<div class="alert alert-warning" role="alert">Please enter a coupon code.</div>');
            return;
        }

        // Clear previous status
        statusDiv.empty();

        // Check if coupon is valid
        if (validCoupons[couponCode]) {
            var coupon = validCoupons[couponCode];
            discountPercentage = coupon.percentage;
            
            // Show success message
            statusDiv.html(
                '<div class="alert alert-success alert-dismissible fade show" role="alert">' +
                '<strong>✓ Coupon Applied!</strong> ' + coupon.description + ' (Save ₹' + 
                Math.round((getOriginalTotal() * coupon.percentage) / 100 * 100) / 100 + ')' +
                '<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>' +
                '</div>'
            );

            // Store coupon for checkout
            $('input[name="applied-coupon"]').remove();
            $('form').append('<input type="hidden" name="applied-coupon" value="' + couponCode + '">');
            $('input[name="coupon-discount"]').remove();
            $('form').append('<input type="hidden" name="coupon-discount" value="' + discountPercentage + '">');

            // Update totals
            updateTotals();
            
            // Disable further coupon changes
            $('#coupon').prop('disabled', true);
            $('#apply-coupon-btn').prop('disabled', true).text('Coupon Applied');
        } else {
            // Invalid coupon
            statusDiv.html(
                '<div class="alert alert-danger alert-dismissible fade show" role="alert">' +
                '<strong>✗ Invalid Coupon!</strong> Please check the code and try again.' +
                '<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>' +
                '</div>'
            );
        }
    });

    /**
     * Remove coupon functionality
     */
    $(document).on('click', '.coupon-remove', function() {
        discountPercentage = 0;
        $('#coupon').val('').prop('disabled', false);
        $('#apply-coupon-btn').prop('disabled', false).text('Apply Coupon');
        $('#coupon-status').empty();
        $('#discount-row').remove();
        $('input[name="applied-coupon"]').remove();
        $('input[name="coupon-discount"]').remove();
        
        // Reset total
        updateTotals();
    });

    /**
     * Recalculate totals when quantity changes
     */
    $(document).on('change', 'input[name="product-quantity"]', function() {
        // Recalculate this row's total
        var row = $(this).closest('tr');
        var quantity = parseInt($(this).val()) || 0;
        var price = parseFloat(row.find('input[name="product-price"]').val()) || 0;
        var newTotal = quantity * price;
        
        row.find('input[name="product-price-total"]').val(newTotal);
        
        // Update cart totals
        updateTotals();
    });

    /**
     * Handle plus/minus buttons
     */
    $('.js-btn-plus').on('click', function() {
        var input = $(this).siblings('input[name="product-quantity"]');
        var val = parseInt(input.val()) || 1;
        input.val(val + 1).change();
    });

    $('.js-btn-minus').on('click', function() {
        var input = $(this).siblings('input[name="product-quantity"]');
        var val = parseInt(input.val()) || 1;
        if (val > 1) {
            input.val(val - 1).change();
        }
    });

    /**
     * Initialize totals on page load
     */
    updateTotals();
});
