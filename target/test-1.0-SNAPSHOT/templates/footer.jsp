<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer class="site-footer border-top">
    <div class="container">
        <div class="row py-5">
            <div class="col-md-3 mb-5 mb-md-0 pr-4">
                <div style="font-size:18px; font-weight:800; letter-spacing:0.2em; color:#fff; text-transform:uppercase; margin-bottom:8px;">JSP Ecom</div>
                <h3 class="footer-heading mb-3">Fan merch store</h3>
                <p style="color:rgba(255,255,255,0.6); font-size:14px; line-height:1.7;">
                    Premium fan gear for Royal Challengers IPL and Red Bull Racing.
                </p>
            </div>

            <div class="col-md-3 mb-5 mb-md-0">
                <h3 class="footer-heading mb-3">Shop</h3>
                <ul class="list-unstyled" style="margin:0; padding:0;">
                    <li style="margin-bottom:10px;"><a href="${pageContext.request.contextPath}/shop" style="color:rgba(255,255,255,0.65); font-size:14px; text-decoration:none;">All merch</a></li>
                    <li style="margin-bottom:10px;"><a href="${pageContext.request.contextPath}/shop" style="color:rgba(255,255,255,0.65); font-size:14px; text-decoration:none;">RCB jersey drops</a></li>
                    <li style="margin-bottom:10px;"><a href="${pageContext.request.contextPath}/order-history" style="color:rgba(255,255,255,0.65); font-size:14px; text-decoration:none;">Order history</a></li>
                </ul>
            </div>

            <div class="col-md-3 mb-5 mb-md-0" style="overflow:hidden;">
                <h3 class="footer-heading mb-3">Contact</h3>
                <ul class="list-unstyled" style="margin:0; padding:0;">
                    <li style="color:rgba(255,255,255,0.70); font-size:14px; margin-bottom:14px; line-height:1.6;">
                        &#x1F4CD; 203 Fake St. Mountain View,<br>San Francisco, CA, USA
                    </li>
                    <li style="margin-bottom:14px;">
                        <a href="tel:+23923929210" style="color:rgba(255,255,255,0.70); text-decoration:none; font-size:14px;">&#x1F4DE; +2 392 3929 210</a>
                    </li>
                    <li style="margin-bottom:14px;">
                        <a href="mailto:info@jspecom.com" style="color:rgba(255,255,255,0.70); text-decoration:none; font-size:14px;">&#x2709;&#xFE0F; info@jspecom.com</a>
                    </li>
                </ul>
            </div>

            <div class="col-md-3 mb-5 mb-md-0">
                <h3 class="footer-heading mb-3">Subscribe</h3>
                <div style="display:flex; gap:8px; align-items:stretch;">
                    <input type="email" id="email_subscribe" placeholder="Your email"
                           style="flex:1; min-width:0; background:rgba(255,255,255,0.08); border:1px solid rgba(255,255,255,0.18); border-radius:10px; color:#fff; padding:10px 14px; font-size:13px; outline:none;">
                    <button type="button" onclick="subscribeNewsletter()"
                            style="flex-shrink:0; background:#c89b58; border:none; border-radius:10px; color:#1b1a17; font-weight:700; font-size:12px; padding:10px 16px; cursor:pointer; white-space:nowrap;">Subscribe</button>
                </div>
                <p style="font-size:12px; color:rgba(255,255,255,0.4); margin-top:10px; line-height:1.5;">Get updates on new drops and exclusive offers.</p>
            </div>
        </div>

        <div class="border-top mt-2 pt-4" style="display:flex; flex-wrap:wrap; justify-content:space-between; align-items:center; gap:8px;">
            <p style="margin:0; color:rgba(255,255,255,0.4); font-size:13px;">
                Copyright &copy;<script>document.write(new Date().getFullYear());</script>
                JSP Ecom. All rights reserved.
            </p>
            <p style="margin:0; color:rgba(255,255,255,0.35); font-size:12px;">
                Template by <a href="https://colorlib.com" target="_blank" rel="noreferrer" style="color:rgba(255,255,255,0.5);">Colorlib</a>.
            </p>
        </div>
    </div>
</footer>
<script>
function subscribeNewsletter() {
    var email = document.getElementById('email_subscribe').value.trim();
    if (!email || !/\S+@\S+\.\S+/.test(email)) { alert('Please enter a valid email address.'); return; }
    var btn = event.currentTarget;
    btn.textContent = 'Subscribed!';
    btn.disabled = true;
    btn.style.background = '#2d7a4f';
    btn.style.color = '#fff';
    document.getElementById('email_subscribe').disabled = true;
}
</script>
