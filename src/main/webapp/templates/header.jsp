<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); %>

<header class="site-navbar" role="banner" style="min-height: auto;">
    <div class="site-navbar-top py-1">
        <div class="container-fluid px-4 px-md-5">
            <div class="row align-items-center">
                
                <!-- Logo -->
                <div class="col-6 col-md-2 order-1 site-logo">
                    <a href="${pageContext.request.contextPath}/" class="js-logo-clone">JSP Ecom</a>
                </div>

                <!-- Navigation Links (Center on Desktop) -->
                <div class="col-12 col-md-6 order-3 order-md-2 text-center d-none d-md-block site-navigation" style="padding: 0;">
                    <ul class="site-menu js-clone-nav d-inline-flex" style="padding: 0; margin: 0; gap: 1rem; align-items: center;">
                        <li class="${home_active}"><a href="${pageContext.request.contextPath}/">Home</a></li>
                        <li class="${about_active}"><a href="${pageContext.request.contextPath}/about.jsp">About</a></li>
                        <li class="${shop_active}"><a href="shop">Shop</a></li>
                        <li class="${contact_active}"><a href="${pageContext.request.contextPath}/contact.jsp">Contact</a></li>
                        <c:if test="${sessionScope.account != null}">
                            <li class="${order_history_active}"><a href="${pageContext.request.contextPath}/order-history">Orders</a></li>
                        </c:if>
                        <c:if test="${sessionScope.account.isSeller == 1}">
                            <li class="${product_management_active}"><a href="${pageContext.request.contextPath}/product-management">Products</a></li>
                            <li class="${order_management_active}"><a href="${pageContext.request.contextPath}/order-management">Manage</a></li>
                        </c:if>
                    </ul>
                </div>

                <!-- Search & Icons -->
                <div class="col-6 col-md-4 order-2 order-md-3 text-right d-flex justify-content-end align-items-center">
                    <form action="search" method="get" class="site-block-top-search mr-3 mb-0" style="max-width: 150px;">
                        <span class="icon icon-search2" style="top: 50%; transform: translateY(-50%);"></span>
                        <input name="keyword" type="text" class="form-control border-0 bg-light" placeholder="Search" style="height: 32px; font-size: 13px; padding-left: 30px;">
                    </form>
                    
                    <div class="site-top-icons">
                        <ul class="d-flex align-items-center m-0 p-0">
                            <c:if test="${sessionScope.account != null}">
                                <li class="dropdown">
                                    <c:if test="${not empty account.base64Image}">
                                        <img class="icon dropdown-toggle" src="data:image/jpg;base64,${account.base64Image}"
                                             id="dropdownMenuReference" data-toggle="dropdown" alt="image"
                                             style="width: 1.5em; border-radius: 50%; margin-right: 10px; cursor: pointer;">
                                    </c:if>
                                    <c:if test="${empty account.base64Image}">
                                        <img class="icon dropdown-toggle" src="${pageContext.request.contextPath}/static/images/blank_avatar.png?v=20260506"
                                             id="dropdownMenuReference" data-toggle="dropdown" alt="image"
                                             style="width: 1.5em; border-radius: 50%; margin-right: 10px; cursor: pointer;">
                                    </c:if>
                                    <div class="dropdown-menu" aria-labelledby="dropdownMenuReference">
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/profile-page" onclick="window.location.href=this.href; return false;">Your profile</a>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/logout" onclick="window.location.href=this.href; return false;">Logout</a>
                                    </div>
                                </li>
                            </c:if>

                            <c:if test="${sessionScope.account == null}">
                                <li><a href="${pageContext.request.contextPath}/login"><span class="icon icon-person"></span></a></li>
                            </c:if>

                            <li>
                                <a href="${pageContext.request.contextPath}/cart.jsp" class="site-cart">
                                    <span class="icon icon-shopping_cart"></span>
                                    <c:if test="${order != null and order.cartProducts != null}">
                                        <span class="count">${order.cartProducts.size()}</span>
                                    </c:if>
                                </a>
                            </li>

                            <li class="d-inline-block d-md-none ml-2">
                                <a href="#" class="site-menu-toggle js-menu-toggle">
                                    <span class="icon-menu"></span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>

            </div>
        </div>
    </div>
</header>
