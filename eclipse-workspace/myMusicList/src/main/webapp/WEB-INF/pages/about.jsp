<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myMusicList.model.UserModel" %>
<%
    UserModel user    = (UserModel) session.getAttribute("loggedUser");
    boolean   isAdmin = "admin".equals(user.getRole());
%>
<!DOCTYPE html>
<html>
<head>
    <title>About – MyMusicList</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<% if (isAdmin) { %>
<body class="admin-body">
<div class="admin-wrapper">

    <!-- ── Admin Sidebar ─────────────────────────────────────────── -->
    <div class="admin-sidebar">
        <div class="sidebar-logo">🎵 MyMusicList</div>
        <p class="sidebar-role">Admin Panel · <%= user.getName() %></p>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard?tab=songs" class="nav-link">🎵 Songs</a>
            <a href="${pageContext.request.contextPath}/admin/dashboard?tab=users" class="nav-link">👤 Users</a>
            <a href="${pageContext.request.contextPath}/about"                     class="nav-link active">ℹ️ About</a>
        </nav>
        <div class="sidebar-bottom">
            <a href="#" class="nav-link logout-link"
               onclick="document.getElementById('logoutModal').classList.add('show'); return false;">
               🚪 Logout
            </a>
        </div>
    </div>

    <!-- ── Admin Main ─────────────────────────────────────────────── -->
    <div class="admin-main">

<% } else { %>
<body class="member-page">
<div class="member-wrapper">

    <!-- ── User Sidebar ──────────────────────────────────────────── -->
    <aside class="member-sidebar">
        <div class="sidebar-logo">🎵 MyMusicList</div>
        <div class="sidebar-greeting">Hi, <strong><%= user.getName() %></strong></div>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/dashboard"  class="nav-link">📚 Library</a>
            <a href="${pageContext.request.contextPath}/playlist"   class="nav-link">🎧 My Playlist</a>
            <a href="${pageContext.request.contextPath}/profile"    class="nav-link">👤 My Profile</a>
            <a href="${pageContext.request.contextPath}/about"      class="nav-link active">ℹ️ About</a>
            <a href="${pageContext.request.contextPath}/contact"    class="nav-link">📬 Contact</a>
        </nav>
        <div class="sidebar-bottom">
            <a href="#" class="nav-link logout-link"
               onclick="document.getElementById('logoutModal').classList.add('show'); return false;">
               🚪 Logout
            </a>
        </div>
    </aside>

    <!-- ── User Main ──────────────────────────────────────────────── -->
    <main class="member-main">

<% } %>

        <!-- ── Hero Banner ──────────────────────────────────────── -->
        <div class="about-hero <%= isAdmin ? "about-hero-admin" : "" %>">
            <div class="about-hero-icon">🎵</div>
            <h1 class="about-hero-title">About MyMusicList</h1>
            <p class="about-hero-sub">
                <%= isAdmin
                    ? "Administrator overview of the platform and its purpose."
                    : "Your personal music library, organised and always within reach." %>
            </p>
        </div>

        <!-- ── Institution Card ─────────────────────────────────── -->
        <div class="<%= isAdmin ? "admin-section" : "member-card" %> about-card">
            <div class="about-section-header">
                <span class="about-section-icon">🏛️</span>
                <h2>About the Institution</h2>
            </div>
            <p>
                MyMusicList is a project developed under the <strong>Faculty of Computing &amp; IT</strong>.
                Our mission is to bridge technology and creativity by building platforms that help students
                and music lovers curate, discover, and manage the music they love — all in one place.
            </p>
            <p>
                The platform is part of a broader academic initiative to explore modern web technologies
                and full-stack development practices, giving students hands-on experience building
                real-world applications.
            </p>
        </div>

        <!-- ── Purpose / Role Card ──────────────────────────────── -->
        <div class="<%= isAdmin ? "admin-section" : "member-card" %> about-card">
            <div class="about-section-header">
                <span class="about-section-icon"><%= isAdmin ? "🛡️" : "🎯" %></span>
                <h2><%= isAdmin ? "Administrator Responsibilities" : "Purpose of MyMusicList" %></h2>
            </div>

            <% if (isAdmin) { %>
            <p>As an administrator of MyMusicList, you are responsible for maintaining the
               quality and integrity of the platform. Your key responsibilities include:</p>
            <div class="about-features-grid">
                <div class="about-feature-item">
                    <span class="feature-icon">🎵</span>
                    <div><strong>Song Management</strong>
                        <p>Add, edit, and remove songs to keep the music library accurate and up to date.</p></div>
                </div>
                <div class="about-feature-item">
                    <span class="feature-icon">👥</span>
                    <div><strong>User Management</strong>
                        <p>Oversee registered users, manage accounts, and ensure a safe environment.</p></div>
                </div>
                <div class="about-feature-item">
                    <span class="feature-icon">📊</span>
                    <div><strong>Content Quality</strong>
                        <p>Review and moderate song metadata to maintain a high-quality catalogue.</p></div>
                </div>
                <div class="about-feature-item">
                    <span class="feature-icon">🔒</span>
                    <div><strong>Platform Security</strong>
                        <p>Ensure data integrity and respond to any platform access concerns promptly.</p></div>
                </div>
            </div>
            <% } else { %>
            <p>MyMusicList is designed to give every music enthusiast a dedicated space to:</p>
            <div class="about-features-grid">
                <div class="about-feature-item">
                    <span class="feature-icon">📚</span>
                    <div><strong>Browse the Library</strong>
                        <p>Explore a curated catalogue of songs organised by title, artist, and genre.</p></div>
                </div>
                <div class="about-feature-item">
                    <span class="feature-icon">🎧</span>
                    <div><strong>Build Your Playlist</strong>
                        <p>Add your favourite tracks to a personal playlist you can manage any time.</p></div>
                </div>
                <div class="about-feature-item">
                    <span class="feature-icon">🔍</span>
                    <div><strong>Search &amp; Filter</strong>
                        <p>Find any song instantly with powerful search and sort capabilities.</p></div>
                </div>
                <div class="about-feature-item">
                    <span class="feature-icon">👤</span>
                    <div><strong>Manage Your Profile</strong>
                        <p>Keep your personal details up-to-date and secure your account.</p></div>
                </div>
            </div>
            <% } %>
        </div>

        <!-- ── Technology Card ──────────────────────────────────── -->
        <div class="<%= isAdmin ? "admin-section" : "member-card" %> about-card">
            <div class="about-section-header">
                <span class="about-section-icon">⚙️</span>
                <h2>Technology</h2>
            </div>
            <p>
                MyMusicList is built with industry-standard Java EE / Jakarta EE technologies,
                including <strong>Servlets</strong>, <strong>JSP</strong>, and a relational
                <strong>MySQL</strong> database — giving students exposure to enterprise-grade
                web development from day one.
            </p>
            <div class="about-tech-badges">
                <span class="tech-badge">☕ Java / Jakarta EE</span>
                <span class="tech-badge">📄 JSP</span>
                <span class="tech-badge">🗄️ MySQL</span>
                <span class="tech-badge">🎨 CSS3</span>
                <span class="tech-badge">🌐 Apache Tomcat</span>
            </div>
        </div>

        <!-- ── Contact CTA (users only) ─────────────────────────── -->
        <% if (!isAdmin) { %>
        <div class="about-cta-banner">
            <span class="cta-icon">📬</span>
            <div>
                <strong>Have a question or feedback?</strong>
                <p>Reach out to our support team — we're happy to help.</p>
            </div>
            <a href="${pageContext.request.contextPath}/contact" class="cta-btn">Contact Us</a>
        </div>
        <% } %>

<% if (isAdmin) { %>
    </div><!-- end admin-main -->
</div><!-- end admin-wrapper -->
<% } else { %>
    </main>
</div><!-- end member-wrapper -->
<% } %>

<!-- Logout modal (shared) -->
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
