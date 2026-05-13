<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer class="site-footer border-top">
    <div class="container">
        <div class="footer-shell row">
            <div class="footer-brand col-md-3 mb-5 mb-md-0">
                <div class="footer-brand__mark">JSP Ecom</div>
                <h3 class="footer-heading mb-4">Fan merch store</h3>
                <p>
                    Premium fan gear for Royal Challengers IPL and Red Bull Racing, laid out with a polished,
                    SaaS-style merchandising experience.
                </p>

                <div class="chip-row chip-row--dark">
                    <span class="chip chip--dark">Limited offers</span>
                    <span class="chip chip--dark">RCB drops</span>
                    <span class="chip chip--dark">Red Bull Racing</span>
                </div>
            </div>

            <div class="footer-links col-md-3 mb-5 mb-md-0">
                <h3 class="footer-heading mb-4">Shop</h3>
                <ul class="list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/shop">All merch</a></li>
                    <li><a href="${pageContext.request.contextPath}/shop">RCB jersey drops</a></li>
                    <li><a href="${pageContext.request.contextPath}/shop">Red Bull racing capsule</a></li>
                    <li><a href="${pageContext.request.contextPath}/order-history">Order history</a></li>
                </ul>
            </div>

            <div class="footer-contact col-md-3 mb-5 mb-md-0">
                <h3 class="footer-heading mb-4">Contact Info</h3>
                <ul class="list-unstyled">
                    <li class="address">203 Fake St. Mountain View, San Francisco, California, USA</li>
                    <li class="phone"><a href="tel://23923929210">+2 392 3929 210</a></li>
                    <li class="email"><a href="mailto:emailaddress@domain.com">emailaddress@domain.com</a></li>
                </ul>
            </div>

            <div class="footer-subscribe col-md-3 mb-5 mb-md-0">
                <h3 class="footer-heading mb-4">Subscribe</h3>
                <form action="#" method="post" class="block-7">
                    <div class="form-group">
                        <input type="text" class="form-control" id="email_subscribe" placeholder="Your email" required>
                        <input type="submit" class="btn btn-sm btn-primary" value="Subscribe">
                    </div>
                </form>
                <p style="font-size: 12px; color: #8b8680; margin-top: 10px;">Subscribe to get updates on new drops and exclusive offers.</p>
            </div>
        </div>

        <div class="footer-bottom border-top mt-5 pt-4">
            <p>
                Copyright &copy;<script>document.write(new Date().getFullYear());</script>
                JSP Ecom. All rights reserved.
            </p>
            <p class="footer-credit">
                Template base by <a href="https://colorlib.com" target="_blank" rel="noreferrer">Colorlib</a>.
                Refreshed for the RCB and Red Bull Racing fan store.
            </p>
        </div>
    </div>
</footer>
