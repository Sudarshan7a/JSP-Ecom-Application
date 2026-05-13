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
                <div class="auth-kicker">Member access</div>
                <h1 class="auth-title" style="color:#fff !important;">Welcome back.</h1>
                <p class="auth-note" style="color:rgba(255,255,255,0.78); max-width: 460px;">
                    Sign in to continue where you left off, manage your cart, and keep the storefront experience seamless.
                </p>
                <div class="chip-row">
                    <span class="chip">Fast checkout</span>
                    <span class="chip">Saved orders</span>
                    <span class="chip">Profile sync</span>
                </div>
            </div>
        </div>
    </div>
    <div class="auth-shell">
        <div class="auth-panel">
            <div class="auth-brand">JSP Ecom</div>
            <div class="auth-card">
                <div class="auth-kicker" style="color: var(--olive);">Login</div>
                <h2 class="auth-title">Access your account</h2>
                <p class="auth-note">Use your username and password to return to your storefront, orders, and profile.</p>

                <div class="alert alert-info mb-3">
                    Demo login: username <strong>demo</strong>, password <strong>demo123</strong>
                </div>

                <form action="login?status=typed" method="post" class="auth-form">
                    ${alert}

                    <div class="form-group mb-3">
                        <input class="form-control input100" type="text" name="username" placeholder="Username">
                    </div>
                    <div class="form-group mb-3">
                        <input class="form-control input100" type="password" name="password" placeholder="Password">
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap" style="gap: 12px;">
                        <label class="d-flex align-items-center mb-0" style="gap: 8px;">
                            <input type="checkbox" name="remember-me-checkbox">
                            <span class="small text-muted">Remember me</span>
                        </label>
                        <a href="#" class="auth-link">Forgot password?</a>
                    </div>

                    <button type="submit" class="login100-form-btn btn btn-primary w-100">Login</button>
                </form>
                <div class="text-center mt-4">
                    <p class="mb-0 text-muted">
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