<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myMusicList.model.UserModel" %>
<%
    UserModel user    = (UserModel) session.getAttribute("loggedUser");
    boolean   isAdmin = "admin".equals(user.getRole());
    if (!isAdmin) request.setAttribute("activeNav", "about");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us – MyMusicList</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>

<% if (isAdmin) { %>
<body class="admin-body">
<div class="admin-wrapper">

    <!-- admin sidebar -->
    <div class="admin-sidebar">
        <div class="sidebar-brand">
            <svg class="sidebar-brand-svg" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 18V5l12-2v13" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <circle cx="6" cy="18" r="3" stroke="white" stroke-width="2"/>
                <circle cx="18" cy="16" r="3" stroke="white" stroke-width="2"/>
            </svg>
            <span>MyMusicList</span>
        </div>
        <p class="sidebar-role">Admin &middot; <%= user.getName() %></p>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard?tab=songs" class="nav-link">
                <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><path d="M5 16V7l10-2v9" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/><circle cx="3.5" cy="16" r="2.5" stroke="currentColor" stroke-width="1.5"/><circle cx="13.5" cy="14" r="2.5" stroke="currentColor" stroke-width="1.5"/></svg>
                Songs
            </a>
            <a href="${pageContext.request.contextPath}/admin/dashboard?tab=users" class="nav-link">
                <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><circle cx="8" cy="7" r="3" stroke="currentColor" stroke-width="1.5"/><path d="M2 17c0-2.761 2.686-5 6-5s6 2.239 6 5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
                Users
            </a>
            <a href="${pageContext.request.contextPath}/about" class="nav-link active">
                <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><circle cx="10" cy="10" r="7.5" stroke="currentColor" stroke-width="1.5"/><path d="M10 9v5M10 7h.01" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
                About Us
            </a>
        </nav>
        <div class="sidebar-bottom">
            <a href="#" class="nav-link nav-link-logout"
               onclick="document.getElementById('logoutModal').classList.add('show'); return false;">
                <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><path d="M7 3H4a1 1 0 00-1 1v12a1 1 0 001 1h3M13 14l3-4-3-4M16 10H7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                Logout
            </a>
        </div>
    </div>

    <!-- admin main -->
    <div class="admin-main">

<% } else { %>
<body class="member-page">
<!-- mobile top bar -->
<div class="mobile-topbar">
    <div class="mobile-brand">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
            <path d="M9 18V5l12-2v13" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <circle cx="6" cy="18" r="3" stroke="white" stroke-width="2"/>
            <circle cx="18" cy="16" r="3" stroke="white" stroke-width="2"/>
        </svg>
        <span>MyMusicList</span>
    </div>
    <button class="hamburger-btn" onclick="toggleSidebar()" aria-label="Menu">
        <span></span><span></span><span></span>
    </button>
</div>
<div class="sidebar-overlay" id="sidebarOverlay" onclick="closeSidebar()"></div>

<div class="member-wrapper">

    <!-- sidebar -->
    <aside class="member-sidebar" id="mobileSidebar">
        <div class="sidebar-brand">
            <svg class="sidebar-brand-svg" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 18V5l12-2v13" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <circle cx="6" cy="18" r="3" stroke="white" stroke-width="2"/>
                <circle cx="18" cy="16" r="3" stroke="white" stroke-width="2"/>
            </svg>
            <span>MyMusicList</span>
        </div>
        <div class="sidebar-greeting">Hi, <strong><%= user.getName() %></strong></div>
        <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
            <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><path d="M4 4h5v5H4zM11 4h5v5h-5zM4 11h5v5H4zM11 11h5v5h-5z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/></svg>
            Library
        </a>
        <a href="${pageContext.request.contextPath}/playlist" class="nav-link">
            <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><path d="M3 5h14M3 10h14M3 15h8" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            My Playlist
        </a>
        <a href="${pageContext.request.contextPath}/queue" class="nav-link">
            <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><path d="M3 5h14M3 10h10M3 15h6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><circle cx="16" cy="15" r="3" stroke="currentColor" stroke-width="1.5"/><path d="M15 15l.7.7 1.3-1.4" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round"/></svg>
            Queue
        </a>
        <a href="${pageContext.request.contextPath}/recentlyPlayed" class="nav-link">
            <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><circle cx="10" cy="10" r="7.5" stroke="currentColor" stroke-width="1.5"/><path d="M10 6v4l2.5 2.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
            Recently Played
        </a>
        <a href="${pageContext.request.contextPath}/about" class="nav-link active">
            <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><circle cx="10" cy="10" r="7.5" stroke="currentColor" stroke-width="1.5"/><path d="M10 9v5M10 7h.01" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            About Us
        </a>
        <a href="${pageContext.request.contextPath}/contact" class="nav-link">
            <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><path d="M2.5 5.5A1.5 1.5 0 014 4h12a1.5 1.5 0 011.5 1.5v9A1.5 1.5 0 0116 16H4a1.5 1.5 0 01-1.5-1.5v-9z" stroke="currentColor" stroke-width="1.5"/><path d="M2.5 6l7.5 5 7.5-5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            Contact
        </a>
        </nav>
        <div class="sidebar-bottom">
            <!-- profile + logout at the bottom -->
            <a href="${pageContext.request.contextPath}/profile" class="sidebar-profile-link">
                <div class="sidebar-pfp">
                    <svg viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <circle cx="10" cy="7" r="3.5" stroke="white" stroke-width="1.5"/>
                        <path d="M3 17c0-3.314 3.134-6 7-6s7 2.686 7 6" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
                    </svg>
                </div>
                <span class="sidebar-pfp-name">My Profile</span>
            </a>
            <a href="#" class="nav-link nav-link-logout"
               onclick="document.getElementById('logoutModal').classList.add('show'); return false;">
                <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><path d="M7 3H4a1 1 0 00-1 1v12a1 1 0 001 1h3M13 14l3-4-3-4M16 10H7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                Logout
            </a>
        </div>
    </aside>

    <!-- user main -->
    <main class="member-main">

<% } %>

        <div class="<%= isAdmin ? "admin-section" : "member-card" %>">

            <!-- hero section -->
            <div class="about-compact-hero">
                <div class="about-hero-icon">🎶</div>
                <div>
                    <h1>About MyMusicList</h1>
                    <p>
                        <%= isAdmin
                            ? "Administrator overview of the platform and its purpose."
                            : "Your personal music library, organised and always within reach." %>
                    </p>
                </div>
            </div>

            <hr class="about-divider">

            <!-- two-col: institution + purpose -->
            <div class="about-two-col">

                <!-- institution info -->
                <div>
                    <div class="about-section-header-compact">
                        <span class="about-section-icon">🎓</span>
                        <h2>About the Institution</h2>
                    </div>
                    <p class="about-body-text">
                        MyMusicList is a project developed under the <strong>Faculty of Computing &amp; IT</strong>.
                        Our mission is to bridge technology and creativity, giving students hands-on experience
                        building real-world full-stack applications.
                    </p>
                </div>

                <!-- purpose / admin responsibilities -->
                <div>
                    <div class="about-section-header-compact">
                        <span class="about-section-icon"><%= isAdmin ? "⚙️" : "🎵" %></span>
                        <h2><%= isAdmin ? "Admin Responsibilities" : "Purpose of MyMusicList" %></h2>
                    </div>
                    <p class="about-body-text">
                        <% if (isAdmin) { %>
                        As an administrator, you maintain the quality and integrity of the platform —
                        managing songs, overseeing users, and ensuring a safe, accurate catalogue.
                        <% } else { %>
                        MyMusicList gives every music enthusiast a dedicated space to browse, build
                        playlists, search, filter, and manage their personal library effortlessly.
                        <% } %>
                    </p>
                </div>

            </div>

            <!-- feature grid -->
            <div class="about-features-grid-compact">
                <% if (isAdmin) { %>
                <div class="about-feature-item-compact">
                    <span class="feature-icon">🎸</span>
                    <div><strong>Song Management</strong><p>Add, edit, and remove songs to keep the library up to date.</p></div>
                </div>
                <div class="about-feature-item-compact">
                    <span class="feature-icon">🧑‍💻</span>
                    <div><strong>User Management</strong><p>Oversee registered users and manage accounts.</p></div>
                </div>
                <div class="about-feature-item-compact">
                    <span class="feature-icon">📋</span>
                    <div><strong>Content Quality</strong><p>Review song metadata to maintain a high-quality catalogue.</p></div>
                </div>
                <div class="about-feature-item-compact">
                    <span class="feature-icon">🔑</span>
                    <div><strong>Platform Security</strong><p>Ensure data integrity and respond to access concerns.</p></div>
                </div>
                <% } else { %>
                <div class="about-feature-item-compact">
                    <span class="feature-icon">🎵</span>
                    <div><strong>Browse the Library</strong><p>Explore songs organised by title, artist, and genre.</p></div>
                </div>
                <div class="about-feature-item-compact">
                    <span class="feature-icon">🎶</span>
                    <div><strong>Build Your Playlist</strong><p>Add favourite tracks to a personal playlist anytime.</p></div>
                </div>
                <div class="about-feature-item-compact">
                    <span class="feature-icon">🔎</span>
                    <div><strong>Search &amp; Filter</strong><p>Find any song instantly with search and sort tools.</p></div>
                </div>
                <div class="about-feature-item-compact">
                    <span class="feature-icon">✏️</span>
                    <div><strong>Manage Your Profile</strong><p>Keep personal details up-to-date and secure.</p></div>
                </div>
                <% } %>
            </div>

            <!-- CTA — only shown to regular users -->
            <% if (!isAdmin) { %>
            <div class="about-cta-banner-compact">
                <span class="cta-icon">💬</span>
                <div>
                    <strong>Have a question or feedback?</strong>
                    <p>Reach out to our support team — we're happy to help.</p>
                </div>
                <a href="${pageContext.request.contextPath}/contact" class="cta-btn">Contact Us</a>
            </div>
            <% } %>

        </div>

<% if (isAdmin) { %>
    </div><!-- end admin-main -->
</div><!-- end admin-wrapper -->
<% } else { %>
    </main>
</div><!-- end member-wrapper -->
<% } %>

<!-- logout modal -->
<div class="logout-modal-overlay" id="logoutModal">
    <div class="logout-modal-box">
        <div class="modal-icon-wrap">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 3H5a2 2 0 00-2 2v14a2 2 0 002 2h4M16 17l5-5-5-5M21 12H9" stroke="#667eea" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
        </div>
        <h3>Sign out</h3>
        <p>Are you sure you want to sign out of MyMusicList?</p>
        <div class="logout-modal-actions">
            <button class="logout-cancel-btn"
                    onclick="document.getElementById('logoutModal').classList.remove('show')">Cancel</button>
            <a href="${pageContext.request.contextPath}/logout">
                <button class="logout-confirm-btn">Yes, Sign out</button>
            </a>
        </div>
    </div>
</div>


<script>
function toggleSidebar(){
    document.getElementById('mobileSidebar').classList.toggle('open');
    document.getElementById('sidebarOverlay').classList.toggle('show');
}
function closeSidebar(){
    document.getElementById('mobileSidebar').classList.remove('open');
    document.getElementById('sidebarOverlay').classList.remove('show');
}
</script>
</body>
</html>
