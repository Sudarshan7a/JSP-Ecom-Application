<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<jsp:include page="templates/head.jsp"/>

<body>
<div class="auth-screen">
    <div class="auth-visual">
        <div class="auth-visual-card">
            <img src="${pageContext.request.contextPath}/static/images/puma-rcb-jersey.png?v=20260506" alt="Premium merch">
            <div class="auth-visual-copy">
                <h1 class="auth-title" style="color:#fff !important; font-size: clamp(28px, 3.5vw, 42px);">Welcome back.</h1>
                <p class="auth-note" style="color:rgba(255,255,255,0.78); max-width: 400px; font-size: 14px;">
                    Sign in to continue shopping, manage your orders, and access exclusive drops.
                </p>
            </div>
        </div>
    </div>
    <div class="auth-shell">
        <div class="auth-panel">
            <div class="auth-brand">JSP Ecom</div>
            <div class="auth-card">
                <h2 class="auth-title" style="font-size: clamp(26px, 3vw, 36px);">Login</h2>
                <p class="auth-note" style="font-size: 14px; margin-bottom: 20px;">Enter your credentials to access your account.</p>

                <div class="alert alert-info mb-3" style="font-size: 13px; padding: 10px 14px; border-radius: 10px;">
                    Demo: <strong>demo</strong> / <strong>demo123</strong>
                </div>

                <form action="login?status=typed" method="post" class="auth-form">
                    ${alert}

                    <div class="form-group mb-3">
                        <input class="form-control input100" type="text" name="username" placeholder="Username" required>
                    </div>
                    <div class="form-group mb-3">
                        <input class="form-control input100" type="password" name="password" placeholder="Password" required>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap" style="gap: 12px;">
                        <label class="d-flex align-items-center mb-0" style="gap: 8px;">
                            <input type="checkbox" name="remember-me-checkbox">
                            <span class="small text-muted">Remember me</span>
                        </label>
                        <a href="#" class="auth-link" style="font-size: 13px;">Forgot password?</a>
                    </div>

                    <button type="submit" class="login100-form-btn btn btn-primary w-100">Login</button>
                </form>
                <div class="text-center mt-4">
                    <p class="mb-0 text-muted" style="font-size: 14px;">
                        Don't have an account?
                        <a href="register.jsp" class="auth-link">Create one</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="templates/scripts.jsp"/>
</body>
</html>