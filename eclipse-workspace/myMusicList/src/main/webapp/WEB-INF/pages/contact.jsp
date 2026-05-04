<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myMusicList.model.UserModel" %>
<%
    UserModel user        = (UserModel) session.getAttribute("loggedUser");
    String contactError   = (String)  request.getAttribute("contactError");
    Boolean contactSuccess = (Boolean) request.getAttribute("contactSuccess");

    // Pre-fill form fields on validation error
    String formName    = request.getAttribute("formName")    != null ? (String) request.getAttribute("formName")    : user.getName();
    String formEmail   = request.getAttribute("formEmail")   != null ? (String) request.getAttribute("formEmail")   : "";
    String formSubject = request.getAttribute("formSubject") != null ? (String) request.getAttribute("formSubject") : "";
    String formMessage = request.getAttribute("formMessage") != null ? (String) request.getAttribute("formMessage") : "";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Contact – MyMusicList</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="member-page">

<div class="member-wrapper">

    <!-- ── Left Sidebar ──────────────────────────────────────────── -->
    <aside class="member-sidebar">
        <div class="sidebar-logo">🎵 MyMusicList</div>
        <div class="sidebar-greeting">Hi, <strong><%= user.getName() %></strong></div>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/dashboard"  class="nav-link">📚 Library</a>
            <a href="${pageContext.request.contextPath}/playlist"   class="nav-link">🎧 My Playlist</a>
            <a href="${pageContext.request.contextPath}/profile"    class="nav-link">👤 My Profile</a>
            <a href="${pageContext.request.contextPath}/about"      class="nav-link">ℹ️ About</a>
            <a href="${pageContext.request.contextPath}/contact"    class="nav-link active">📬 Contact</a>
        </nav>
        <div class="sidebar-bottom">
            <a href="#" class="nav-link logout-link"
               onclick="document.getElementById('logoutModal').classList.add('show'); return false;">
               🚪 Logout
            </a>
        </div>
    </aside>

    <!-- ── Main Content ───────────────────────────────────────────── -->
    <main class="member-main">

        <!-- Page Header -->
        <div class="contact-hero">
            <div class="contact-hero-icon">📬</div>
            <h1 class="contact-hero-title">Get in Touch</h1>
            <p class="contact-hero-sub">Have a question, suggestion, or issue? We'd love to hear from you.</p>
        </div>

        <div class="contact-layout">

            <!-- ── Support Info Panel ──────────────────────────────── -->
            <div class="contact-info-panel member-card">
                <h3>🛠️ Support Details</h3>

                <div class="contact-info-item">
                    <span class="contact-info-icon">📧</span>
                    <div>
                        <strong>Email Support</strong>
                        <p>support@mymusiclist.edu</p>
                        <small>Response within 24 hours on working days</small>
                    </div>
                </div>

                <div class="contact-info-item">
                    <span class="contact-info-icon">📞</span>
                    <div>
                        <strong>Phone</strong>
                        <p>+977 01-4XXXXXX</p>
                        <small>Mon – Fri, 9 AM – 5 PM (NPT)</small>
                    </div>
                </div>

                <div class="contact-info-item">
                    <span class="contact-info-icon">📍</span>
                    <div>
                        <strong>Location</strong>
                        <p>Faculty of Computing &amp; IT</p>
                        <small>Kathmandu, Nepal</small>
                    </div>
                </div>

                <div class="contact-info-item">
                    <span class="contact-info-icon">🕐</span>
                    <div>
                        <strong>Office Hours</strong>
                        <p>Sunday – Friday</p>
                        <small>9:00 AM – 5:00 PM (NPT)</small>
                    </div>
                </div>

                <hr class="contact-divider">

                <div class="contact-faq-link">
                    <span>💡</span>
                    <div>
                        <strong>Common Issues</strong>
                        <p>For password resets or account problems, visit your
                           <a href="${pageContext.request.contextPath}/profile">Profile page</a> first
                           or use <a href="${pageContext.request.contextPath}/forgot-password">Forgot Password</a>.
                        </p>
                    </div>
                </div>
            </div>

            <!-- ── Inquiry Form ───────────────────────────────────── -->
            <div class="member-card contact-form-card">
                <h3>📝 Send an Inquiry</h3>

                <% if (Boolean.TRUE.equals(contactSuccess)) { %>
                <div class="contact-success-box">
                    <div class="contact-success-icon">✅</div>
                    <h4>Message Sent!</h4>
                    <p>Thank you for reaching out, <strong><%= user.getName() %></strong>.
                       Our support team will get back to you shortly.</p>
                    <a href="${pageContext.request.contextPath}/contact" class="contact-send-btn" style="display:inline-block;text-decoration:none;margin-top:10px;">
                        Send Another
                    </a>
                </div>
                <% } else { %>

                <% if (contactError != null) { %>
                <div class="banner error" style="margin-bottom:16px;">⚠️ <%= contactError %></div>
                <% } %>

                <form action="${pageContext.request.contextPath}/contact" method="post" class="contact-form" novalidate>

                    <div class="contact-form-row">
                        <div class="contact-field">
                            <label for="cName">Full Name <span class="required">*</span></label>
                            <input type="text" id="cName" name="name"
                                   value="<%= formName %>"
                                   placeholder="Your name" required>
                        </div>
                        <div class="contact-field">
                            <label for="cEmail">Email Address <span class="required">*</span></label>
                            <input type="email" id="cEmail" name="email"
                                   value="<%= formEmail %>"
                                   placeholder="your@email.com" required>
                        </div>
                    </div>

                    <div class="contact-field">
                        <label for="cSubject">Subject <span class="required">*</span></label>
                        <select id="cSubject" name="subject" required>
                            <option value="" disabled <%= formSubject.isEmpty() ? "selected" : "" %>>Select a subject…</option>
                            <option value="General Inquiry"    <%= "General Inquiry".equals(formSubject)    ? "selected" : "" %>>General Inquiry</option>
                            <option value="Account Support"    <%= "Account Support".equals(formSubject)    ? "selected" : "" %>>Account Support</option>
                            <option value="Song / Library Issue" <%= "Song / Library Issue".equals(formSubject) ? "selected" : "" %>>Song / Library Issue</option>
                            <option value="Playlist Problem"   <%= "Playlist Problem".equals(formSubject)   ? "selected" : "" %>>Playlist Problem</option>
                            <option value="Bug Report"         <%= "Bug Report".equals(formSubject)         ? "selected" : "" %>>Bug Report</option>
                            <option value="Feature Request"    <%= "Feature Request".equals(formSubject)    ? "selected" : "" %>>Feature Request</option>
                            <option value="Other"              <%= "Other".equals(formSubject)              ? "selected" : "" %>>Other</option>
                        </select>
                    </div>

                    <div class="contact-field">
                        <label for="cMessage">Message <span class="required">*</span></label>
                        <textarea id="cMessage" name="message" rows="6"
                                  placeholder="Describe your question or issue in detail…"
                                  required><%= formMessage %></textarea>
                    </div>

                    <button type="submit" class="contact-send-btn">📨 Send Message</button>
                </form>

                <% } %>
            </div>

        </div><!-- end .contact-layout -->

    </main>
</div>

<!-- Logout modal -->
<div class="logout-modal-overlay" id="logoutModal">
    <div class="logout-modal-box">
        <div class="modal-icon">🚪</div>
        <h3>Logout</h3>
        <p>Are you sure you want to logout?</p>
        <div class="logout-modal-actions">
            <button class="logout-cancel-btn"
                    onclick="document.getElementById('logoutModal').classList.remove('show')">Cancel</button>
            <a href="${pageContext.request.contextPath}/logout">
                <button class="logout-confirm-btn">Yes, Logout</button>
            </a>
        </div>
    </div>
</div>

</body>
</html>
