<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<jsp:include page="templates/head.jsp"/>

<body>
<div class="auth-screen">
    <div class="auth-visual">
        <div class="auth-visual-card">
            <img src="${pageContext.request.contextPath}/static/images/red-bull-racing-capsule.svg?v=20260506" alt="Premium merch capsule">
            <div class="auth-visual-copy">
                <div class="auth-kicker">Create account</div>
                <h1 class="auth-title" style="color:#fff !important;">Unlock merch drops.</h1>
                <p class="auth-note" style="color:rgba(255,255,255,0.78); max-width: 460px;">
                    Build your account to save fan gear, track orders, and move through checkout faster.
                </p>
                <div class="chip-row">
                    <span class="chip">RCB drops</span>
                    <span class="chip">Red Bull Racing</span>
                    <span class="chip">Secure access</span>
                </div>
            </div>
        </div>
    </div>
    <div class="auth-shell">
        <div class="auth-panel">
            <div class="auth-brand">JSP Ecom</div>
            <div class="auth-card">
                <div class="auth-kicker" style="color: var(--olive);">Sign up</div>
                <h2 class="auth-title">Create your merch account</h2>
                <p class="auth-note">Register once to personalize the storefront, save fan drops, and keep your shopping history in one place.</p>

                <div class="alert alert-info mb-3">
                    Demo mode creates a local session account when DB credentials are missing.
                </div>

                <form action="register" method="post" class="auth-form" enctype="multipart/form-data">
                    ${alert}

                    <div class="mb-4 text-center">
                        <label class="m-0" for="imgInp" style="cursor: pointer; display: inline-block;">
                            <img id="blah" src="${pageContext.request.contextPath}/static/images/blank_avatar.png?v=20260506" alt="Profile preview"
                                 style="width: 8.5rem; height: 8.5rem; object-fit: cover; border-radius: 50%;">
                            <div class="mt-3 text-muted small">Click to upload profile image</div>
                        </label>
                        <input name="profile-image" type="file" id="imgInp" style="display: none;">
                    </div>
                    <div class="form-group mb-3">
                        <input class="form-control input100" type="text" name="username" placeholder="Username">
                    </div>
                    <div class="form-group mb-3">
                        <input class="form-control input100" type="password" name="password" placeholder="Password">
                    </div>
                    <div class="form-group mb-3">
                        <input class="form-control input100" type="password" name="repeat-password" placeholder="Repeat password">
                    </div>
                    <button type="submit" class="login100-form-btn btn btn-primary w-100">Sign up</button>
                </form>

                <div class="text-center mt-4">
                    <p class="mb-0 text-muted">
                        Already have an account?
                        <a href="login.jsp" class="auth-link">Login here</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="templates/scripts.jsp"/>
</body>
</html>