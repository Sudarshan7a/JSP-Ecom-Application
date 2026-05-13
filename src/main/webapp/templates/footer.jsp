<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer class="site-footer border-top">
    <div class="container">
        <div class="footer-shell row py-5">
            <div class="footer-brand col-md-3 mb-5 mb-md-0 pr-4">
                <div class="footer-brand__mark mb-2" style="font-size:18px; font-weight:800; letter-spacing:0.2em; color:#fff; text-transform:uppercase;">JSP Ecom</div>
                <h3 class="footer-heading mb-3">Fan merch store</h3>
                <p style="color:rgba(255,255,255,0.6); font-size:14px; line-height:1.7;">
                    Premium fan gear for Royal Challengers IPL and Red Bull Racing, laid out with a polished,
                    SaaS-style merchandising experience.
                </p>

                <div style="display:flex; flex-wrap:wrap; gap:8px; margin-top:16px;">
                    <span style="display:inline-block; padding:5px 10px; border:1px solid rgba(255,255,255,0.2); border-radius:20px; font-size:11px; color:rgba(255,255,255,0.75);">Limited offers</span>
                    <span style="display:inline-block; padding:5px 10px; border:1px solid rgba(255,255,255,0.2); border-radius:20px; font-size:11px; color:rgba(255,255,255,0.75);">RCB drops</span>
                    <span style="display:inline-block; padding:5px 10px; border:1px solid rgba(255,255,255,0.2); border-radius:20px; font-size:11px; color:rgba(255,255,255,0.75);">Red Bull Racing</span>
                </div>
            </div>

            <div class="footer-links col-md-3 mb-5 mb-md-0">
                <h3 class="footer-heading mb-3">Shop</h3>
                <ul class="list-unstyled" style="margin:0; padding:0;">
                    <li style="margin-bottom:10px;"><a href="${pageContext.request.contextPath}/shop" style="color:rgba(255,255,255,0.65); font-size:14px; text-decoration:none;">All merch</a></li>
                    <li style="margin-bottom:10px;"><a href="${pageContext.request.contextPath}/shop" style="color:rgba(255,255,255,0.65); font-size:14px; text-decoration:none;">RCB jersey drops</a></li>
                    <li style="margin-bottom:10px;"><a href="${pageContext.request.contextPath}/shop" style="color:rgba(255,255,255,0.65); font-size:14px; text-decoration:none;">Red Bull racing capsule</a></li>
                    <li style="margin-bottom:10px;"><a href="${pageContext.request.contextPath}/order-history" style="color:rgba(255,255,255,0.65); font-size:14px; text-decoration:none;">Order history</a></li>
                </ul>
            </div>

            <div class="footer-contact col-md-3 mb-5 mb-md-0 block-5">
                <h3 class="footer-heading mb-3">Contact Info</h3>
                <ul class="list-unstyled" style="margin:0; padding:0;">
                    <li style="color:rgba(255,255,255,0.70); font-size:14px; margin-bottom:12px; padding-left:28px; position:relative; line-height:1.6;">
                        <span style="position:absolute; left:0; top:2px; font-family:icomoon; content:'\e8b4'; font-size:16px; color:#c89b58;">&#xe8b4;</span>
                        203 Fake St. Mountain View, San Francisco, California, USA
                    </li>
                    <li style="color:rgba(255,255,255,0.70); font-size:14px; margin-bottom:12px; padding-left:28px; position:relative;">
                        <span style="position:absolute; left:0; top:2px; font-family:icomoon; font-size:16px; color:#c89b58;">&#xf095;</span>
                        <a href="tel://23923929210" style="color:rgba(255,255,255,0.70); text-decoration:none;">+2 392 3929 210</a>
                    </li>
                    <li style="color:rgba(255,255,255,0.70); font-size:14px; margin-bottom:12px; padding-left:28px; position:relative;">
                        <span style="position:absolute; left:0; top:2px; font-family:icomoon; font-size:16px; color:#c89b58;">&#xf0e0;</span>
                        <a href="mailto:emailaddress@domain.com" style="color:rgba(255,255,255,0.70); text-decoration:none;">emailaddress@domain.com</a>
                    </li>
                </ul>
            </div>

            <div class="footer-subscribe col-md-3 mb-5 mb-md-0">
                <h3 class="footer-heading mb-3">Subscribe</h3>
                <div style="display:flex; flex-wrap:wrap; gap:8px; align-items:stretch;">
                    <input type="email" id="email_subscribe" placeholder="Your email address"
                           style="flex:1 1 130px; min-width:0; background:rgba(255,255,255,0.08); border:1px solid rgba(255,255,255,0.18); border-radius:10px; color:#fff; padding:10px 14px; font-size:13px; outline:none; transition:border-color 0.2s;">
                    <button type="button" onclick="subscribeNewsletter()"
                            style="flex-shrink:0; background:#c89b58; border:none; border-radius:10px; color:#1b1a17; font-weight:700; font-size:12px; letter-spacing:0.06em; padding:10px 16px; cursor:pointer; white-space:nowrap; transition:background 0.2s;">Subscribe</button>
                </div>
                <p style="font-size: 12px; color: rgba(255,255,255,0.4); margin-top: 10px; line-height:1.5;">Subscribe to get updates on new drops and exclusive offers.</p>
            </div>
        </div>

        <div class="footer-bottom border-top mt-2 pt-4" style="display:flex; flex-wrap:wrap; justify-content:space-between; align-items:center; gap:8px;">
            <p style="margin:0; color:rgba(255,255,255,0.4); font-size:13px;">
                Copyright &copy;<script>document.write(new Date().getFullYear());</script>
                JSP Ecom. All rights reserved.
            </p>
            <p class="footer-credit" style="margin:0; color:rgba(255,255,255,0.35); font-size:12px;">
                Template base by <a href="https://colorlib.com" target="_blank" rel="noreferrer" style="color:rgba(255,255,255,0.5);">Colorlib</a>.
                Refreshed for the RCB and Red Bull Racing fan store.
            </p>
        </div>
    </div>
</footer>
<script>
function subscribeNewsletter() {
    var email = document.getElementById('email_subscribe').value.trim();
    if (!email || !/\S+@\S+\.\S+/.test(email)) { alert('Please enter a valid email address.'); return; }
    var btn = event.currentTarget;
    btn.textContent = '✓ Subscribed!';
    btn.disabled = true;
    btn.style.background = '#2d7a4f';
    btn.style.color = '#fff';
    document.getElementById('email_subscribe').disabled = true;
}
</script>
