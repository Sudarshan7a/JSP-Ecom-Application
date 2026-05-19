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
                        class="text-black">${product.name}</strong></div>
            </div>
        </div>
    </div>

    <div class="site-section">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <img src="${product.imageSource}" alt="Image" class="img-fluid"
                        onerror="this.onerror=null; this.src='static/images/puma-rcb-jersey.png';">
                </div>

                <div class="col-md-6">
                    <h2 class="text-black">${product.name}</h2>

                    <p>${product.description}</p>

                    <p><strong class="product-price">₹${product.price}</strong></p>

                    <c:choose>
                        <c:when test="${product.amount <= 0}">
                            <div class="alert alert-danger d-flex align-items-center justify-content-between mb-3" role="alert" style="gap: 12px;">
                                <div>
                                    <strong>Out of stock.</strong> This item is currently unavailable.
                                </div>
                                <span class="badge badge-light" style="padding: 8px 12px; font-size: 12px; text-transform: uppercase; letter-spacing: 0.06em;">Unavailable</span>
                            </div>
                            <p class="text-muted mb-4">Check back later or browse similar items in the featured products below.</p>
                        </c:when>
                        <c:otherwise>
                            <form action="${pageContext.request.contextPath}/cart" method="get">
                                <div class="mb-3">
                                    <div class="input-group mb-3" style="max-width: 200px;">
                                        <input name="product-id" value="${product.id}" type="hidden">

                                        <div class="input-group-prepend">
                                            <button class="btn btn-outline-primary js-btn-minus" type="button">&minus;</button>
                                        </div>

                                        <input id="quantity" name="quantity" type="text" class="form-control text-center"
                                               value="1" placeholder="" aria-label="Example text with button addon"
                                               aria-describedby="button-addon1" style="max-width: 50px">

                                        <div class="input-group-append">
                                            <button class="btn btn-outline-primary js-btn-plus" type="button">&plus;</button>
                                        </div>

                                        <label for="quantity" class="form-label text-black">
                                            Available products: ${product.amount}
                                        </label>
                                    </div>
                                </div>

                                <p>
                                    <button type="submit" class="buy-now btn btn-sm btn-primary" ${disabled}>
                                        Add To Cart
                                    </button>
                                </p>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <c:if test="${alert}">
                <div class="row justify-content-center mt-3">
                    <div class="alert alert-danger d-flex justify-content-center" role="alert"
                         data-aos="fade-up" style="max-width: 800px; min-width: 600px">
                        <strong class="font-weight-bold">
                            There are only ${product.amount} available in stock!
                        </strong>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <jsp:include page="templates/featured-products.jsp"/>

    <jsp:include page="templates/footer.jsp"/>
</div>

<jsp:include page="templates/scripts.jsp"/>
</body>
</html>
