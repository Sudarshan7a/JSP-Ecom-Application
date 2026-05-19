<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                        class="text-black">Thank you</strong></div>
            </div>
        </div>
    </div>

    <div class="site-section">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8">

                    <!-- Success header -->
                    <div class="text-center mb-5">
                        <span class="icon-check_circle display-3 text-success d-block mb-3"></span>
                        <h2 class="display-4 text-black mb-2">Order Placed!</h2>
                        <p class="lead text-muted">
                            <c:if test="${not empty sessionScope.placed_order_name}">
                                Thank you, <strong>${sessionScope.placed_order_name}</strong>!&nbsp;
                            </c:if>
                            Your order has been successfully placed and is being processed.
                        </p>
                    </div>

                    <!-- Order summary card -->
                    <div class="p-4 border mb-4" style="border-radius: 16px; background: #fffdf9;">
                        <h4 class="text-black mb-4" style="border-bottom: 2px solid #c89b58; padding-bottom: 12px;">Order Summary</h4>

                        <c:choose>
                            <c:when test="${not empty sessionScope.placed_order_items}">
                                <table class="table site-block-order-table mb-4">
                                    <thead>
                                        <tr>
                                            <th>Product</th>
                                            <th style="text-align:center;">Qty</th>
                                            <th style="text-align:right;">Unit Price</th>
                                            <th style="text-align:right;">Subtotal</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${sessionScope.placed_order_items}" var="item">
                                            <tr>
                                                <td>
                                                    <strong>${item.product.name}</strong>
                                                    <c:if test="${item.product.category != null}">
                                                        <br><small class="text-muted">${item.product.category.name}</small>
                                                    </c:if>
                                                </td>
                                                <td style="text-align:center;">${item.quantity}</td>
                                                <td style="text-align:right;">&#8377;${item.price}</td>
                                                <td style="text-align:right;">&#8377;${item.price * item.quantity}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>

                                <c:if test="${not empty sessionScope.placed_order_coupon_code}">
                                    <div class="alert alert-success mb-4">
                                        Coupon <strong>${sessionScope.placed_order_coupon_code}</strong> applied.
                                        You saved &#8377;<fmt:formatNumber value="${sessionScope.placed_order_discount}" type="number" maxFractionDigits="2"/>.
                                    </div>
                                </c:if>

                                <div class="d-flex justify-content-between align-items-center py-3 border-top">
                                    <span class="h5 text-black mb-0 font-weight-bold">Total Charged</span>
                                    <span class="h4 font-weight-bold" style="color: #1f4d3a;">
                                        &#8377;<fmt:formatNumber value="${sessionScope.placed_order_total}" type="number" maxFractionDigits="2"/>
                                    </span>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted text-center py-3">Your order has been recorded. Check order history for details.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Actions -->
                    <div class="text-center">
                        <a href="${pageContext.request.contextPath}/order-history" class="btn btn-primary btn-lg mr-3">View Order History</a>
                        <a href="${pageContext.request.contextPath}/shop" class="btn btn-outline-primary btn-lg">Continue Shopping</a>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <jsp:include page="templates/footer.jsp"/>
</div>

<jsp:include page="templates/scripts.jsp"/>
</body>
</html>