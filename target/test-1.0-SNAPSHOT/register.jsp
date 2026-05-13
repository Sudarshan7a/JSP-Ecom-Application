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
                <h1 class="auth-title" style="color:#fff !important; font-size: clamp(28px, 3.5vw, 42px);">Join the store.</h1>
                <p class="auth-note" style="color:rgba(255,255,255,0.78); max-width: 400px; font-size: 14px;">
                    Create an account to save your cart, track orders, and get exclusive merch drops.
                </p>
            </div>
        </div>
    </div>
    <div class="auth-shell">
        <div class="auth-panel">
            <div class="auth-brand">JSP Ecom</div>
            <div class="auth-card">
                <h2 class="auth-title" style="font-size: clamp(26px, 3vw, 36px);">Create account</h2>
                <p class="auth-note" style="font-size: 14px; margin-bottom: 20px;">Sign up to start shopping premium fan gear.</p>

                <form action="register" method="post" class="auth-form" enctype="multipart/form-data">
                    ${alert}

                    <div class="mb-4 text-center">
                        <label class="m-0" for="imgInp" style="cursor: pointer; display: inline-block;">
                            <img id="blah" src="${pageContext.request.contextPath}/static/images/blank_avatar.png?v=20260506" alt="Profile preview"
                                 style="width: 6rem; height: 6rem; object-fit: cover; border-radius: 50%; border: 2px solid #e5dfd6;">
                            <div class="mt-2 text-muted" style="font-size: 12px;">Upload photo (optional)</div>
                        </label>
                        <input name="profile-image" type="file" id="imgInp" style="display: none;">
                    </div>
                    <div class="form-group mb-3">
                        <input class="form-control input100" type="text" name="username" placeholder="Username" required>
                    </div>
                    <div class="form-group mb-3">
                        <input class="form-control input100" type="password" name="password" placeholder="Password" required>
                    </div>
                    <div class="form-group mb-3">
                        <input class="form-control input100" type="password" name="repeat-password" placeholder="Repeat password" required>
                    </div>
                    <button type="submit" class="login100-form-btn btn btn-primary w-100">Sign up</button>
                </form>

                <div class="text-center mt-4">
                    <p class="mb-0 text-muted" style="font-size: 14px;">
                        Already have an account?
                        <a href="login.jsp" class="auth-link">Login here</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="templates/scripts.jsp"/>
<script>
document.getElementById('imgInp').addEventListener('change', function() {
    var reader = new FileReader();
    reader.onload = function(e) {
        document.getElementById('blah').src = e.target.result;
    };
    if (this.files[0]) reader.readAsDataURL(this.files[0]);
});
</script>
</body>
</html>