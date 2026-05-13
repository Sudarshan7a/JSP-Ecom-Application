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
                <div class="col-md-12 mb-0">
                    <a href="${pageContext.request.contextPath}/">Home</a>
                    <span class="mx-2 mb-0">/</span>
                    <strong class="text-black">Order History</strong>
                </div>
            </div>
        </div>
    </div>

    <div class="site-section">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-10">

                    <c:choose>
                        <c:when test="${not empty order_list}">
                            <div class="mb-4">
                                <h2 class="text-black h4 text-uppercase mb-1">Your Orders</h2>
                                <p class="text-muted">${order_list.size()} order(s) found</p>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-bordered" style="border-radius: 12px; overflow: hidden;">
                                    <thead>
                                        <tr>
                                            <th>Order #</th>
                                            <th>Date</th>
                                            <th>Total (₹)</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${order_list}" var="o">
                                            <tr>
                                                <td class="font-weight-bold">#${o.id}</td>
                                                <td>
                                                    <fmt:formatDate value="${o.date}" pattern="dd MMM yyyy"/>
                                                </td>
                                                <td class="font-weight-bold" style="color: var(--primary, #1f4d3a);">
                                                    &#8377;<fmt:formatNumber value="${o.totalPrice}" type="number" minFractionDigits="0" maxFractionDigits="2"/>
                                                </td>
                                                <td>
                                                    <span style="display:inline-block; padding: 4px 12px; background: #e8f5e9; color: #2e7d32; border-radius: 20px; font-size: 12px; font-weight: 600;">
                                                        Delivered
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="order-detail?order_id=${o.id}" class="btn btn-outline-primary btn-sm">
                                                        View Details
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="text-center py-5">
                                <span class="icon-shopping_cart" style="font-size: 64px; color: #ccc; display: block; margin-bottom: 20px;"></span>
                                <h3 class="text-black mb-3">No Orders Yet</h3>
                                <p class="text-muted mb-4">You haven't placed any orders yet. Browse our collection and find something you love!</p>
                                <a href="${pageContext.request.contextPath}/shop" class="btn btn-primary px-5 py-3">
                                    Shop Now
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>
        </div>
    </div>

    <jsp:include page="templates/footer.jsp"/>
</div>

<jsp:include page="templates/scripts.jsp"/>
</body>
</html>
