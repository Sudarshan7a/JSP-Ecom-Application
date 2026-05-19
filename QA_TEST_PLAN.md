# QA Test Plan: JSP E-Commerce RCB Merchandise Store

You are an expert QA tester for e-commerce websites. Thoroughly test the JSP E-Commerce RCB merchandise store end-to-end and report any issues, broken flows, missing functionality, or UX problems.

**Test Environment:** http://localhost:8080  
**Database:** MariaDB on port 33306  
**Test Date:** [Date]  
**Tester:** [Name]

---

## PAGES TO TEST:

1. **Home** (`/`)
2. **Shop / Product Listing** (`/shop`, `/shop-new`)
3. **Product Detail** (`/product-detail?id=X`)
4. **Cart** (`/cart.jsp`)
5. **Checkout** (`/checkout`)
6. **Thank You / Order Confirmation** (`/thankyou.jsp`)
7. **Profile / Account** (`/profile-page`)
8. **Order History** (`/order-history`)
9. **Order Details** (`/order-detail?order_id=X`)
10. **About** (`/about.jsp`)
11. **Contact** (`/contact.jsp`)
12. **Contact Management** (`/contact-management`)
13. **Login** (`/login`)
14. **Register** (`/register`)
15. **Search Results** (`/search?keyword=X`)
16. **Category Filter** (`/category?category_id=X`)
17. **Error Pages** (404, 500, etc.)

---

## USER FLOWS TO TEST:

1. **Create New User (Registration)**
2. **Login / Logout**
3. **Browse & Search Products**
4. **Sort & Filter Products**
5. **View Product Details**
6. **Add to Cart**
7. **Update Cart Quantity**
8. **Remove from Cart**
9. **Apply Coupon/Discount (e.g., RCB25)**
10. **Proceed to Checkout**
11. **Place Order**
12. **View Order History**
13. **View Order Details** (including discounted prices)
14. **Edit Profile Information**
15. **Submit Contact Form**
16. **Responsive Design / Mobile Layout**

---

## CRITICAL USER STORIES TO VERIFY:

### Story 1: Product Image & Name Are Clickable

- **Expected:** Product image AND product name should link to product-detail page
- **Test:** Click image → should open product-detail; click name → should open product-detail
- **Pages:** `/shop`, `/shop-new`, featured products carousel

### Story 2: Coupon Application & Discount Persistence

- **Expected:**
  - Apply coupon code `RCB25` (25% discount) in cart
  - Discount should appear in order history and order-detail pages
  - Order-detail page should show **discounted unit prices**, not original prices
- **Test:**
  1. Add products to cart
  2. Apply coupon `RCB25`
  3. Verify discount shown in cart total
  4. Proceed to checkout
  5. View order in order-history
  6. Click order-detail and verify prices are discounted

### Story 3: Out-of-Stock Product Handling

- **Expected:**
  - Products with stock <= 0 should show "Out of stock" badge
  - "Add to Cart" button should be disabled or show "View" only
  - Product detail page should clearly indicate unavailability
- **Test:** Find a product with 0 stock (or manually set one), verify UI state

### Story 4: Product Clickability (Image & Text)

- **Expected:** Both product image and product name should be clickable links to product-detail
- **Test:** On `/shop` and `/shop-new`, click product image → should navigate to product-detail; click product name → should navigate to product-detail

### Story 5: Contact Form Persistence

- **Expected:** Contact submissions should be saved to database and visible in `/contact-management`
- **Test:**
  1. Fill contact form on `/contact.jsp` with valid data
  2. Submit form
  3. Navigate to `/contact-management`
  4. Verify submission appears in the list

---

## DETAILED TEST CASES:

### 1. HOME PAGE (`/`)

**Checks:**

- [ ] Page loads without errors (HTTP 200)
- [ ] Header navigation links are visible and functional
- [ ] Featured products carousel displays (if present)
- [ ] Hero section / banner is visible
- [ ] "Shop Now" or main CTA button works
- [ ] Footer links are visible
- [ ] Logo is displayed and clickable (returns to home)
- [ ] Mobile responsive (test on 375px, 768px, 1024px widths)
- [ ] Page title is appropriate (e.g., "JSP Ecom — Premium Fan Merch Store")

---

### 2. SHOP / PRODUCT LISTING (`/shop`, `/shop-new`)

**Checks:**

- [ ] Page loads without errors
- [ ] Product grid displays multiple products (min 4 per row on desktop)
- [ ] Product images load correctly (no broken images)
- [ ] Product name, price, and category are visible for each item
- [ ] Stock badge shows "Limited" or "Out of stock" appropriately
- [ ] **Product image is clickable → opens product-detail page**
- [ ] **Product name is clickable → opens product-detail page**
- [ ] "View" button works → opens product-detail page
- [ ] Pagination works if more than ~20 products
- [ ] Category sidebar displays all categories
- [ ] Category filter works (click category → filters products)
- [ ] Sort dropdown works (Relevance, Name A-Z, Price Low-High, etc.)
- [ ] Results update correctly when sorting/filtering
- [ ] Cart icon in header shows correct count
- [ ] Mobile responsive

**Edge Cases:**

- [ ] Test with search that returns 0 results → should show "No products available" message
- [ ] Test with category that has 0 products → should show empty state

---

### 3. PRODUCT DETAIL PAGE (`/product-detail?id=X`)

**Checks:**

- [ ] Page loads without errors
- [ ] Product image displays and is zoomable/viewable (if gallery present)
- [ ] Product name, price, and description are visible
- [ ] Category label shown
- [ ] Stock/availability status shown:
  - [ ] If stock > 0: "Add to Cart" button is enabled
  - [ ] If stock <= 0: "Add to Cart" button is disabled OR shows "View" only
  - [ ] Out of stock badge shown if applicable
- [ ] Quantity selector works (increment/decrement)
- [ ] "Add to Cart" button adds item to cart
- [ ] Related products / recommendations shown (if available)
- [ ] Breadcrumb navigation works
- [ ] Mobile responsive
- [ ] Product rating/reviews shown (if applicable)

**Edge Cases:**

- [ ] Add more items than available stock → should show error or cap at max
- [ ] Add to cart while logged out → should either add to guest cart or redirect to login (check behavior)

---

### 4. CART PAGE (`/cart.jsp`)

**Checks:**

- [ ] Page loads without errors
- [ ] All added products display with correct image, name, price
- [ ] Quantity of each item shows correctly
- [ ] Unit price and total price per item calculate correctly
- [ ] Cart subtotal displays correctly
- [ ] Quantity can be incremented/decremented using +/- buttons
- [ ] Totals recalculate when quantity changes
- [ ] Remove button removes item from cart
- [ ] Empty cart message shows if no items
- [ ] **Coupon code input field is present**
- [ ] **Coupon code `RCB25` can be applied and shows 25% discount**
- [ ] Discount amount displays in cart total
- [ ] "Proceed to Checkout" button navigates to checkout
- [ ] Cart persists after page refresh (if user account present)
- [ ] Mobile responsive

**Edge Cases:**

- [ ] Apply invalid coupon → should show error message
- [ ] Apply coupon multiple times → should not stack discounts
- [ ] Remove coupon → should recalculate totals without discount
- [ ] Quantity = 0 → should remove item or show validation
- [ ] Continue shopping → should return to shop

---

### 5. CHECKOUT PAGE (`/checkout`)

**Checks:**

- [ ] Page loads without errors (requires login or demo mode)
- [ ] Cart items summary shown on right/left side
- [ ] Subtotal, discount (if coupon applied), and final total all display
- [ ] **Discounted total from cart is preserved and shown here**
- [ ] Shipping address form displays with fields:
  - [ ] First Name
  - [ ] Last Name
  - [ ] Address
  - [ ] Email
  - [ ] Phone
- [ ] All required fields have validation
- [ ] Submit form creates order
- [ ] Order is saved to database with correct total and coupon info
- [ ] Redirects to thank-you page after successful checkout

**Edge Cases:**

- [ ] Submit with empty fields → validation errors shown
- [ ] Submit with invalid email → error shown
- [ ] Empty cart → checkout should not be allowed

---

### 6. THANK YOU / ORDER CONFIRMATION (`/thankyou.jsp`)

**Checks:**

- [ ] Page loads after checkout
- [ ] Order confirmation message displays
- [ ] Order summary shown (items, quantities, total)
- [ ] **Discounted total shown correctly**
- [ ] **Coupon code shown (if applied)**
- [ ] Shipping address displayed
- [ ] "Continue Shopping" button works
- [ ] "View Order" or "Order History" link works

---

### 7. ORDER HISTORY (`/order-history`)

**Checks:**

- [ ] Page accessible only when logged in
- [ ] Lists all user orders with:
  - [ ] Order ID
  - [ ] Order date
  - [ ] Order total (should show discounted total if coupon was applied)
  - [ ] Status (Delivered, Pending, etc.)
  - [ ] "View Details" button
- [ ] "View Details" button navigates to order-detail page
- [ ] Order count displayed correctly
- [ ] Empty state if no orders
- [ ] Mobile responsive

---

### 8. ORDER DETAILS PAGE (`/order-detail?order_id=X`)

**CRITICAL TEST:**

- [ ] Page loads without errors
- [ ] Displays table with columns: Product ID, Quantity, **Price (INR)**, Total
- [ ] **Price column shows PAID price (discounted if coupon was applied), NOT original price**
- [ ] If order #1002 was placed with RCB25 coupon (25% off):
  - [ ] Original price: ₹3499, Paid price: ₹2624.25 (or similar 25% reduction)
  - [ ] Each line item shows the discounted unit price
- [ ] All order items listed correctly
- [ ] Total price calculation matches order total from order-history
- [ ] Product names/IDs link to product detail (if desired)
- [ ] Mobile responsive

**This is the most important verification of the discount persistence fix.**

---

### 9. PROFILE / ACCOUNT PAGE (`/profile-page`)

**Checks:**

- [ ] Page requires login; redirects to login if not authenticated
- [ ] Displays user information: Name, Email, Address, Phone
- [ ] "Edit Profile" form present with fields:
  - [ ] First Name
  - [ ] Last Name
  - [ ] Address
  - [ ] Email
  - [ ] Phone
- [ ] Update profile saves changes to database
- [ ] Changes persist after page refresh
- [ ] "Orders" or "Order History" link present
- [ ] Password change functionality (if available)
- [ ] Mobile responsive

---

### 10. CONTACT FORM (`/contact.jsp`)

**Checks:**

- [ ] Page loads without errors
- [ ] Form fields present:
  - [ ] First Name
  - [ ] Last Name
  - [ ] Email
  - [ ] Subject
  - [ ] Message
- [ ] Submit button works
- [ ] **After submission, success message appears**
- [ ] **Submission is saved to `contact_messages` table in database**
- [ ] Empty fields show validation errors
- [ ] Invalid email format shows error
- [ ] Mobile responsive

**Verification:**

- [ ] Navigate to `/contact-management` and verify submitted message appears in list

---

### 11. CONTACT MANAGEMENT (`/contact-management`)

**Checks:**

- [ ] Page accessible (may require admin or logged-in user)
- [ ] Lists all contact submissions with:
  - [ ] Name
  - [ ] Email
  - [ ] Subject
  - [ ] Submission date/time
  - [ ] Message (truncated or full view)
- [ ] Submissions from contact form appear here
- [ ] Sort/search functionality (if available)
- [ ] Mobile responsive

---

### 12. LOGIN PAGE (`/login`)

**Checks:**

- [ ] Page loads without errors
- [ ] Form fields: Email/Username, Password
- [ ] "Sign in" button navigates to form (or shows demo hint if applicable)
- [ ] **No hardcoded "demo" credentials visible in UI** ✓ (Fixed)
- [ ] Valid login redirects to home or dashboard
- [ ] Invalid password shows error: "Invalid credentials" or similar
- [ ] After login, user name shown in header (if present)
- [ ] Logout clears session and redirects to login
- [ ] Mobile responsive

**Edge Cases:**

- [ ] SQL injection attempt in email field → should not break
- [ ] Try wrong email → error shown
- [ ] Try empty fields → validation error

---

### 13. REGISTRATION PAGE (`/register`)

**Checks:**

- [ ] Page loads without errors
- [ ] Form fields present:
  - [ ] First Name
  - [ ] Last Name
  - [ ] Email
  - [ ] Password
  - [ ] Confirm Password
- [ ] Submit button works
- [ ] Validation:
  - [ ] Empty fields show error
  - [ ] Invalid email format shows error
  - [ ] Password mismatch shows error
  - [ ] Weak password validation (if applicable)
- [ ] Successful registration redirects to login or auto-logs in
- [ ] New account can be used to log in
- [ ] Mobile responsive

---

### 14. SEARCH RESULTS (`/search?keyword=X`)

**Checks:**

- [ ] Search for existing product (e.g., "jersey") → relevant results shown
- [ ] Search for non-existent product (e.g., "xyz123") → "No products found" message
- [ ] Search results display as product grid (same as shop page)
- [ ] Product links work
- [ ] Sort/filter options work on search results
- [ ] Keyword highlighted in results (if applicable)
- [ ] Mobile responsive

---

### 15. CATEGORY FILTER (`/category?category_id=X`)

**Checks:**

- [ ] Clicking category from sidebar filters products
- [ ] URL changes to `/category?category_id=X`
- [ ] Only products in selected category display
- [ ] Category name shown in breadcrumb or header
- [ ] Product count updates
- [ ] Can apply additional filters (sort) while in category
- [ ] Mobile responsive

---

### 16. ABOUT PAGE (`/about.jsp`)

**Checks:**

- [ ] Page loads without errors
- [ ] Content displays correctly
- [ ] Images load (no broken images)
- [ ] Links are functional
- [ ] Mobile responsive

---

### 17. RESPONSIVE DESIGN & MOBILE

**Test on Multiple Viewports:**

- [ ] 375px (iPhone SE)
- [ ] 768px (iPad)
- [ ] 1024px (Desktop)
- [ ] 1440px (Large Desktop)

**Checks for all pages:**

- [ ] No horizontal scrolling on mobile
- [ ] Text is readable without zoom
- [ ] Buttons/links are touch-friendly (min 44px tall)
- [ ] Navigation menu collapses/expands properly
- [ ] Images scale appropriately
- [ ] Forms are usable on mobile
- [ ] Modals/popups fit viewport

---

## CRITICAL EDGE CASES TO TEST:

### 1. Stock Management

- [ ] Product with 0 stock shows as "Out of stock"
- [ ] Cannot add out-of-stock item to cart (or button is disabled)
- [ ] Add more items to cart than available stock → error or cap at max

### 2. Coupon/Discount Persistence

- [ ] Apply `RCB25` coupon in cart
- [ ] Verify discount in checkout
- [ ] **Verify discounted prices in order-detail page**
- [ ] Order total matches discounted total from checkout
- [ ] Invalid coupon code shows error

### 3. Empty States

- [ ] Empty cart → shows message, no checkout button
- [ ] No order history → shows "No orders found"
- [ ] No search results → shows friendly message
- [ ] No contact messages → shows "No messages" (for admin)

### 4. Session Management

- [ ] Add item to cart, log out, log back in → cart still present (if persisted)
- [ ] Add item to cart, close browser, reopen → cart state depends on implementation
- [ ] Logout → redirects to login page
- [ ] Accessing `/profile-page` while logged out → redirects to login

### 5. Form Validation

- [ ] All required fields must be filled
- [ ] Email format validation
- [ ] Password strength validation (if applicable)
- [ ] Phone number format validation
- [ ] No script injection in text fields

### 6. Performance

- [ ] Shop page with many products loads in < 3 seconds
- [ ] Cart calculations happen instantly when updating quantities
- [ ] Search results return in < 1 second

---

## REPORTING FORMAT:

For every issue found, report in this format:

```
PAGE/FLOW: [name]
ISSUE: [describe what is wrong]
STEPS TO REPRODUCE: [numbered steps]
EXPECTED: [what should happen]
ACTUAL: [what actually happened]
SEVERITY: Critical / High / Medium / Low
SCREENSHOT: [if applicable]
```

### Severity Definitions:

- **Critical:** Blocks core workflow (e.g., cannot checkout, cannot log in, broken database)
- **High:** Feature not working as expected, affects user experience significantly
- **Medium:** Minor UX issue, cosmetic problem, or less critical functionality
- **Low:** Typo, minor layout shift, or edge case

---

## TEST SIGN-OFF:

- **Total Issues Found:** \_\_\_
  - Critical: \_\_\_
  - High: \_\_\_
  - Medium: \_\_\_
  - Low: \_\_\_

- **Flows That Passed:**
  - [ ] Registration
  - [ ] Login
  - [ ] Browse Products
  - [ ] Add to Cart
  - [ ] Apply Coupon
  - [ ] Checkout
  - [ ] Order History
  - [ ] Order Details (with discounted prices)
  - [ ] Profile Update
  - [ ] Contact Form
  - [ ] Search
  - [ ] Category Filter

- **Top 3 Priority Fixes:**
  1. [Issue]
  2. [Issue]
  3. [Issue]

---

**Tester Name:** ********\_********  
**Date Tested:** ********\_********  
**Environment:** http://localhost:8080  
**Build Version:** test-1.0-SNAPSHOT
