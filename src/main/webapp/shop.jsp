<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); %>

<!DOCTYPE html>
<html lang="en">
<jsp:include page="templates/head.jsp"/>

<body>
<div class="site-wrap">
    <jsp:include page="templates/header.jsp"/>

    <div class="breadcrumb">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <a href="${pageContext.request.contextPath}/">Home</a> 
                    <span class="mx-2">/</span> 
                    <strong>Shop All Products</strong>
                </div>
            </div>
        </div>
    </div>

    <main class="product-section">
        <div class="container-fluid px-4 px-lg-5">
            <div class="row mb-5">
                <!-- Sidebar -->
                <div class="col-md-2 order-1 mb-5 mb-md-0">
                    <div class="sidebar">
                        <h3 class="sidebar-title">Categories</h3>
                        <ul class="category-list mb-5">
                            <li class="${empty param.category_id and empty param.keyword ? 'active-category' : ''}">
                                <a href="${pageContext.request.contextPath}/shop">
                                    <span>All Products</span>
                                </a>
                            </li>
                            <c:forEach items="${category_list}" var="category">
                                <li class="${param.category_id == category.id ? 'active-category' : ''}">
                                    <a href="category?category_id=${category.id}">
                                        <span>${category.name}</span>
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                        
                        <h3 class="sidebar-title">Sort By</h3>
                        <div class="sort-dropdown" style="width: 100%;">
                            <select id="sortSelect" onchange="sortProducts()" style="width: 100%; padding: 10px; border: 1px solid var(--border-color); border-radius: var(--radius-sm); font-family: inherit;">
                                <option value="relevance">Relevance</option>
                                <option value="name-asc">Name, A to Z</option>
                                <option value="name-desc">Name, Z to A</option>
                                <option value="price-asc">Price, Low to High</option>
                                <option value="price-desc">Price, High to Low</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="col-md-10 order-2">
                    <div class="section-header mb-4">
                        <h1 class="section-title">Premium RCB Merchandise</h1>
                    </div>

                    <!-- Product Grid - 4 items per row for wider layout -->
                    <div class="product-grid" style="grid-template-columns: repeat(4, minmax(0, 1fr)) !important;">
                        <c:forEach items="${product_list}" var="product" varStatus="status">
                            <div class="product-card" data-aos="fade-up">
                                <div class="product-image">
                                    <img src="${product.imageSource}" 
                                         alt="${product.name}"
                                         onerror="this.src='static/images/puma-rcb-jersey.png';">
                                    <span class="badge">Limited</span>
                                </div>
                                <div class="product-info">
                                    <p class="product-category">
                                        <c:if test="${product.category != null}">
                                            ${product.category.name}
                                        </c:if>
                                        <c:if test="${product.category == null}">
                                            Premium
                                        </c:if>
                                    </p>
                                    <h3 class="product-name">${product.name}</h3>
                                    <p class="product-description">${product.description}</p>
                                    <div class="product-footer">
                                        <div class="product-price">₹${product.price}</div>
                                        <a href="product-detail?id=${product.id}" class="product-btn">View</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <c:if test="${empty product_list}">
                            <div style="grid-column: 1/-1; text-align: center; padding: 3rem;">
                                <h3 style="color: #999;">No products available</h3>
                                <p style="color: #bbb;">Please check back soon for our premium merchandise collection.</p>
                            </div>
                        </c:if>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${total_pages > 1}">
                        <div class="pagination">
                            <c:if test="${page_active > 1}">
                                <a href="shop?index=${page_active - 1}">← Previous</a>
                            </c:if>

                            <c:forEach begin="1" end="${total_pages}" var="i">
                                <c:choose>
                                    <c:when test="${page_active == i}">
                                        <span class="active">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="shop?index=${i}">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:if test="${page_active < total_pages}">
                                <a href="shop?index=${page_active + 1}">Next →</a>
                            </c:if>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="templates/footer.jsp"/>
</div>

<script>
function sortProducts() {
    const sortValue = document.getElementById('sortSelect').value;
    console.log('Sort by:', sortValue);
}

// Initialize AOS animation library if available
if (typeof AOS !== 'undefined') {
    AOS.init({
        duration: 1000,
        once: true
    });
}
</script>

<script src="${pageContext.request.contextPath}/static/js/jquery-3.3.1.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/aos.js"></script>
<script src="${pageContext.request.contextPath}/static/js/category-filter.js"></script>

</body>
</html>
