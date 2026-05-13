/**
 * Category Filter Functionality  
 * Enhances filter interactions and provides visual feedback
 */

jQuery(document).ready(function ($) {
    "use strict";

    // Add loading spinner to products
    var addLoadingSpinner = function() {
        var productGrid = $('.product-grid');
        if (productGrid.length) {
            productGrid.css({
                'opacity': '0.6',
                'pointer-events': 'none'
            });
            
            // Add loading message
            if (!$('.loading-spinner').length) {
                productGrid.prepend(
                    '<div class="loading-spinner" style="grid-column: 1/-1; text-align: center; padding: 2rem;">' +
                    '<div style="display: inline-block; font-size: 24px; color: #888;">Loading products...</div>' +
                    '</div>'
                );
            }
        }
    };

    var removeLoadingSpinner = function() {
        var productGrid = $('.product-grid');
        if (productGrid.length) {
            productGrid.css({
                'opacity': '1',
                'pointer-events': 'auto'
            });
            
            $('.loading-spinner').remove();
        }
    };

    // Enhance category links with visual feedback
    $('.category-list a').on('click', function (e) {
        var categoryCount = $(this).find('.category-count');
        if (categoryCount.length) {
            // Add pulse animation to show the filter is active
            categoryCount.css({
                'animation': 'pulse 0.6s ease-out'
            });
            
            setTimeout(function() {
                categoryCount.css('animation', 'none');
            }, 600);
        }
    });

    /**
     * Add CSS animation for pulse effect
     */
    var style = document.createElement('style');
    style.innerHTML = `
        @keyframes pulse {
            0% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.15); opacity: 1; }
            100% { transform: scale(1); opacity: 1; }
        }
    `;
    document.head.appendChild(style);

    /**
     * Handle sort dropdown
     */
    $('#sortSelect').on('change', function () {
        var sortValue = $(this).val();
        var products = $('.product-card');
        var productArray = [];

        products.each(function () {
            var name = $(this).find('.product-name').text().trim();
            var priceText = $(this).find('.product-price').text().trim().replace('₹', '').trim();
            var price = parseFloat(priceText) || 0;
            
            productArray.push({
                element: $(this).clone(true),
                name: name,
                price: price
            });
        });

        // Sort based on selection
        switch (sortValue) {
            case 'name-asc':
                productArray.sort((a, b) => a.name.localeCompare(b.name));
                break;
            case 'name-desc':
                productArray.sort((a, b) => b.name.localeCompare(a.name));
                break;
            case 'price-asc':
                productArray.sort((a, b) => a.price - b.price);
                break;
            case 'price-desc':
                productArray.sort((a, b) => b.price - a.price);
                break;
            default: // relevance
                // Keep original order
                break;
        }

        // Clear and re-append products in sorted order
        var productGrid = $('.product-grid');
        productGrid.empty();
        
        $.each(productArray, function (index, item) {
            productGrid.append(item.element);
        });

        // Re-initialize AOS animations
        if (typeof AOS !== 'undefined') {
            AOS.refresh();
        }

        // Scroll to products
        $('html, body').animate({
            scrollTop: productGrid.offset().top - 100
        }, 300);
    });

    /**
     * Add subtle animation when products load
     */
    var observeProductGrid = function() {
        var productGrid = $('.product-grid');
        if (productGrid.length) {
            productGrid.css({
                'animation': 'fadeIn 0.4s ease-out'
            });
        }
    };

    // Add fade-in animation to page
    var style2 = document.createElement('style');
    style2.innerHTML = `
        @keyframes fadeIn {
            from { opacity: 0.8; }
            to { opacity: 1; }
        }
    `;
    document.head.appendChild(style2);

    // Observe for product grid changes
    observeProductGrid();

    /**
     * Enhance category sidebar with active state
     */
    var currentPath = window.location.href;
    $('.category-list a').each(function() {
        var href = $(this).attr('href');
        if (href && (currentPath.includes(href) || currentPath.includes('category_id=' + href.match(/\d+/)))) {
            $(this).closest('li').css({
                'background-color': '#f6f1ea',
                'border-radius': '4px'
            });
            $(this).css('color', 'var(--accent)');
        }
    });
});

