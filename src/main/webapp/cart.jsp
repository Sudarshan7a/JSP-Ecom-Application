<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); %>

<!DOCTYPE html>
<html lang="en">
<jsp:include page="templates/head.jsp"/>

<body>
<div class="site-wrap">
    <jsp:include page="templates/header.jsp"/>

    <div class="bg-light py-3">
        <div class="container">
            <div class="row">
                <div class="col-md-12 mb-0"><a href="${pageContext.request.contextPath}/">Home</a> <span class="mx-2 mb-0">/</span> <strong
                        class="text-black">Cart</strong></div>
            </div>
        </div>
    </div>

    <div class="site-section">
        <form class="container" method="post" action="checkout">
            <div class="row mb-5">
                <div class="col-md-12">
                    <div class="site-blocks-table">
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th class="product-thumbnail">Image</th>
                                <th class="product-name">Product</th>
                                <th class="product-price">Price (INR)</th>
                                <th class="product-quantity">Quantity</th>
                                <th class="product-total">Total</th>
                                <th class="product-remove">Remove</th>
                            </tr>
                            </thead>

                            <tbody>
                            <c:if test="${empty order or empty order.cartProducts}">
                                <tr>
                                    <td colspan="6" class="text-center py-5">
                                        Your cart is empty. Browse the shop to add premium merch.
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach items="${order.cartProducts}" var="o">
                                <tr>
                                    <td class="product-thumbnail">
                                        <img src="${o.product.imageSource}" alt="Image"
                                             class="img-fluid"
                                             onerror="this.onerror=null; this.src='static/images/placeholder.svg';">
                                    </td>

                                    <td>
                                        <input name="product-name" class="form-control-plaintext h5 text-black"
                                               value="${o.product.name}" style="text-align: center" readonly>
                                    </td>

                                    <td>
                                        <input name="product-price" class="form-control-plaintext h5 text-black"
                                               value="${o.price}" style="text-align: center" readonly>
                                    </td>

                                    <td style="min-width: 180px">
                                        <div class="input-group" style="max-width: fit-content; margin: 0;">
                                            <div class="input-group-prepend">
                                                <button class="btn btn-outline-primary js-btn-minus" type="button">
                                                    &minus;
                                                </button>
                                            </div>

                                            <input name="product-quantity" type="text" class="form-control text-center"
                                                   value="${o.quantity}"
                                                   placeholder=""
                                                   aria-label="Example text with button addon"
                                                   aria-describedby="button-addon1">

                                            <div class="input-group-append">
                                                <button class="btn btn-outline-primary js-btn-plus" type="button">
                                                    &plus;
                                                </button>
                                            </div>
                                        </div>
                                    </td>

                                    <td>
                                        <input name="product-price-total" class="form-control-plaintext h5 text-black"
                                               value="${o.price * o.quantity}" style="text-align: center" readonly>
                                    </td>

                                    <td><a href="cart?remove-product-id=${o.product.id}" class="btn btn-primary btn-sm">X</a></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="row mb-5">
                        <div class="col-md-6 mb-3 mb-md-0">
                            <a href="${pageContext.request.contextPath}/shop" class="btn btn-outline-primary btn-sm btn-block">Continue shopping</a>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <label class="text-black h4" for="coupon">Coupon</label>
                            <p>Enter your coupon code if you have one.</p>
                        </div>
                        <div class="col-md-8 mb-3 mb-md-0">
                            <input type="text" class="form-control py-3" id="coupon" placeholder="Coupon Code">
                        </div>
                        <div class="col-md-4">
                            <button id="apply-coupon-btn" type="button" class="btn btn-primary btn-sm">Apply Coupon</button>
                        </div>
                        <div class="col-md-12 mt-2">
                            <small class="text-muted">Try demo coupon: <strong>RCB25</strong> for 25% off (display only).</small>
                            <div id="coupon-status" class="mt-2"></div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 pl-5">
                    <div class="row justify-content-end">
                        <div class="col-md-8">
                            <div class="row">
                                <div class="col-md-12 text-right border-bottom mb-4">
                                    <h3 class="text-black h4 text-uppercase">Cart Totals</h3>
                                </div>
                            </div>

                            <!-- Subtotal row -->
                            <div class="row mb-3">
                                <div class="col-6">
                                    <span class="text-muted">Subtotal</span>
                                </div>
                                <div class="col-6 text-right">
                                    <span id="cart-subtotal-display" class="h6 text-black">
                                        &#8377;${empty total_price ? 0 : total_price}
                                    </span>
                                    <input type="hidden" name="order-price-total" id="order-price-total-hidden"
                                           value="${empty total_price ? 0 : total_price}">
                                </div>
                            </div>

                            <!-- Discount row (shown only when coupon applied) -->
                            <div id="discount-row" class="row mb-3" style="display:none;">
                                <div class="col-6">
                                    <span class="text-success" id="discount-label">Discount</span>
                                </div>
                                <div class="col-6 text-right">
                                    <span class="text-success h6" id="discount-amount">-&#8377;0</span>
                                </div>
                            </div>

                            <!-- Final Total row -->
                            <div class="row mb-5 border-top pt-3">
                                <div class="col-6">
                                    <span class="text-black font-weight-bold" style="font-size: 1.2em">Total</span>
                                </div>
                                <div class="col-6 text-right">
                                    <span id="cart-final-total" class="h5 text-black font-weight-bold">
                                        &#8377;${empty total_price ? 0 : total_price}
                                    </span>
                                    <!-- Hidden field carries the discounted total to checkout -->
                                    <input type="hidden" name="discounted-total" id="discounted-total"
                                           value="${empty total_price ? 0 : total_price}">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-12">
                                    <!-- Submit (not anchor) so hidden fields pass through form POST -->
                                    <button type="submit" class="btn btn-primary btn-lg py-3 btn-block"
                                            formaction="checkout">
                                        Proceed To Checkout
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <jsp:include page="templates/footer.jsp"/>
</div>

<jsp:include page="templates/scripts.jsp"/>
<script src="${pageContext.request.contextPath}/static/js/coupon-handler.js"></script>
</body>
</html>
