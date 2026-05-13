<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); %>

<div class="site-section site-blocks-2">
    <div class="container">
        <div class="row">
            <c:forEach items="${category_list}" var="o">
                <div class="col-sm-6 col-md-6 col-lg-4 mb-4 mb-lg-0" data-aos="fade" data-aos-delay="">
                    <a class="block-2-item" href="${pageContext.request.contextPath}/category?category_id=${o.id}">
                        <figure class="image">
                            <c:choose>
                                <c:when test="${o.name == 'Men'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Men.jpg?v=20260506" alt="${o.name}" class="img-fluid">
                                </c:when>
                                <c:when test="${o.name == 'Women'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Women.jpg?v=20260506" alt="${o.name}" class="img-fluid">
                                </c:when>
                                <c:when test="${o.name == 'Children'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Children.jpg?v=20260506" alt="${o.name}" class="img-fluid">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/static/images/puma-rcb-jersey.png?v=20260506" alt="${o.name}" class="img-fluid">
                                </c:otherwise>
                            </c:choose>
                        </figure>

                        <div class="text">
                            <span class="text-uppercase">Collections</span>
                            <h3>${o.name}</h3>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>
</div>