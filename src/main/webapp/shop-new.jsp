<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <div class="container">
            <div class="row mb-5" style="gap: 2rem;">
                <!-- Sidebar -->
                <div class="col-md-3 order-1 mb-5 mb-md-0">
                    <div class="sidebar">
                        <h3 class="sidebar-title">Categories</h3>
                        <ul class="category-list">
                            <c:forEach items="${category_list}" var="category">
                                <li>
                                    <a href="category?category_id=${category.id}">
                                        <span>${category.name}</span>
                                        <span class="category-count">${category.totalCategoryProduct}</span>
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="col-md-9 order-2">
                    <div class="section-header">
                        <h1 class="section-title">Premium RCB Merchandise</h1>
                        <div class="sort-dropdown">
                            <select id="sortSelect" onchange="sortProducts()">
                                <option value="relevance">Sort by Relevance</option>
                                <option value="name-asc">Name, A to Z</option>
                                <option value="name-desc">Name, Z to A</option>
                                <option value="price-asc">Price, Low to High</option>
                                <option value="price-desc">Price, High to Low</option>
                            </select>
                        </div>
                    </div>

                    <!-- Product Grid -->
                    <div class="product-grid">
                        <c:forEach items="${product_list}" var="product" varStatus="status">
                            <div class="product-card" data-aos="fade-up">
                                <div class="product-image">
                                    <a href="product-detail?id=${product.id}">
                                        <img src="${product.imageSource}" 
                                             alt="${product.name}"
                                             onerror="this.src='static/images/puma-rcb-jersey.png';">
                                    </a>
                                    <c:choose>
                                        <c:when test="${product.amount <= 0}">
                                            <span class="badge" style="background:#c62828; color:#fff;">Out of stock</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge">Limited</span>
                                        </c:otherwise>
                                    </c:choose>
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
                                    <h3 class="product-name"><a href="product-detail?id=${product.id}">${product.name}</a></h3>
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
    const grid = document.querySelector('.product-grid');
    if (!grid) return;
    const cards = Array.from(grid.querySelectorAll('.product-card'));
    if (cards.length === 0) return;

    cards.sort(function(a, b) {
        const nameA = (a.querySelector('.product-name') || a.querySelector('h3') || {textContent:''}).textContent.trim();
        const nameB = (b.querySelector('.product-name') || b.querySelector('h3') || {textContent:''}).textContent.trim();
        const priceA = parseFloat((a.querySelector('.product-price') || {textContent:'0'}).textContent.replace(/[^\d.]/g, '')) || 0;
        const priceB = parseFloat((b.querySelector('.product-price') || {textContent:'0'}).textContent.replace(/[^\d.]/g, '')) || 0;

        switch (sortValue) {
            case 'name-asc':  return nameA.localeCompare(nameB);
            case 'name-desc': return nameB.localeCompare(nameA);
            case 'price-asc': return priceA - priceB;
            case 'price-desc': return priceB - priceA;
            default: return 0; // relevance — original order
        }
    });

    cards.forEach(function(card) { grid.appendChild(card); });
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

</body>
</html>
