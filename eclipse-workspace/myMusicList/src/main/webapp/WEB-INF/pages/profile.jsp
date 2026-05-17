<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myMusicList.model.UserModel" %>
<%
    UserModel user     = (UserModel) session.getAttribute("loggedUser");
    UserModel fullUser = (UserModel) request.getAttribute("fullUser");
    if (fullUser == null) fullUser = user;

    String profileError   = (String) request.getAttribute("profileError");
    String profileSuccess = (String) request.getAttribute("profileSuccess");
    String pwError        = (String) request.getAttribute("pwError");
    String pwSuccess      = (String) request.getAttribute("pwSuccess");
    String secError       = (String) request.getAttribute("secError");
    String secSuccess     = (String) request.getAttribute("secSuccess");

    String currentQuestion = fullUser.getSecurityQuestion();
    boolean hasQuestion    = currentQuestion != null && !currentQuestion.trim().isEmpty();
    request.setAttribute("activeNav", "profile");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile – MyMusicList</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
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
        <a href="${pageContext.request.contextPath}/about" class="nav-link">
            <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><circle cx="10" cy="10" r="7.5" stroke="currentColor" stroke-width="1.5"/><path d="M10 9v5M10 7h.01" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            About Us
        </a>
        <a href="${pageContext.request.contextPath}/contact" class="nav-link">
            <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><path d="M2.5 5.5A1.5 1.5 0 014 4h12a1.5 1.5 0 011.5 1.5v9A1.5 1.5 0 0116 16H4a1.5 1.5 0 01-1.5-1.5v-9z" stroke="currentColor" stroke-width="1.5"/><path d="M2.5 6l7.5 5 7.5-5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            Contact
        </a>
        </nav>
        <div class="sidebar-bottom">
            <!-- profile link, highlighted when on profile page -->
            <a href="${pageContext.request.contextPath}/profile" class="sidebar-profile-link sidebar-profile-link--active">
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

    <main class="member-main">

        <!-- page header with avatar -->
        <div class="member-card member-card-flush">
            <div class="profile-page-header">
                <div class="profile-avatar-large">
                    <svg viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <circle cx="10" cy="7" r="3.5" stroke="white" stroke-width="1.5"/>
                        <path d="M3 17c0-3.314 3.134-6 7-6s7 2.686 7 6" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
                    </svg>
                </div>
                <div class="profile-header-info">
                    <h2><%= user.getName() %></h2>
                    <p><%= user.getEmail() %></p>
                </div>
                <span class="profile-role-badge"><%= user.getRole() %></span>
            </div>

            <!-- stacked form sections -->
            <div class="profile-sections-stack">

            <!-- personal info + password side by side -->
            <div class="profile-top-row">

                <!-- personal info -->
                <div class="profile-section-card">
                    <h3 class="compact-card-title">Personal Info</h3>
                    <% if (profileError != null) { %><div class="alert"><%= profileError %></div><% } %>
                    <% if (profileSuccess != null) { %><div class="alert success"><%= profileSuccess %></div><% } %>
                    <form action="${pageContext.request.contextPath}/profile" method="post">
                        <input type="hidden" name="action" value="updateProfile">
                        <div class="profile-field">
                            <label class="field-label">Full Name</label>
                            <div class="input-group">
                                <span class="input-icon">
                                    <svg viewBox="0 0 16 16" fill="none" class="icon-xs"><circle cx="8" cy="5" r="3" stroke="#888" stroke-width="1.4"/><path d="M2 14c0-2.761 2.686-5 6-5s6 2.239 6 5" stroke="#888" stroke-width="1.4" stroke-linecap="round"/></svg>
                                </span>
                                <input type="text" name="name" value="<%= user.getName() %>" required>
                            </div>
                        </div>
                        <div class="profile-field">
                            <label class="field-label">Email <span class="field-hint">(read-only)</span></label>
                            <div class="input-group">
                                <span class="input-icon">
                                    <svg viewBox="0 0 16 16" fill="none" class="icon-xs"><rect x="1.5" y="3.5" width="13" height="9" rx="1.5" stroke="#888" stroke-width="1.4"/><path d="M1.5 5l6.5 4.5L14.5 5" stroke="#888" stroke-width="1.4" stroke-linecap="round"/></svg>
                                </span>
                                <input type="email" value="<%= user.getEmail() %>" disabled class="input-disabled">
                            </div>
                        </div>
                        <button type="submit" class="submit-btn">Save Changes</button>
                    </form>
                </div>

                <!-- change password -->
                <div class="profile-section-card">
                    <h3 class="compact-card-title">Change Password</h3>
                    <% if (pwError != null) { %><div class="alert"><%= pwError %></div><% } %>
                    <% if (pwSuccess != null) { %><div class="alert success"><%= pwSuccess %></div><% } %>
                    <form action="${pageContext.request.contextPath}/profile" method="post">
                        <input type="hidden" name="action" value="changePassword">
                        <div class="profile-field">
                            <label class="field-label">Current Password</label>
                            <div class="input-group">
                                <span class="input-icon">
                                    <svg viewBox="0 0 16 16" fill="none" class="icon-xs"><rect x="3" y="7" width="10" height="7" rx="1.5" stroke="#888" stroke-width="1.4"/><path d="M5 7V5a3 3 0 016 0v2" stroke="#888" stroke-width="1.4" stroke-linecap="round"/></svg>
                                </span>
                                <input type="password" name="oldPassword" placeholder="Current password" required>
                            </div>
                        </div>
                        <div class="profile-field">
                            <label class="field-label">New Password <span class="field-hint">(min 8)</span></label>
                            <div class="input-group">
                                <span class="input-icon">
                                    <svg viewBox="0 0 16 16" fill="none" class="icon-xs"><rect x="3" y="7" width="10" height="7" rx="1.5" stroke="#888" stroke-width="1.4"/><path d="M5 7V5a3 3 0 016 0v2" stroke="#888" stroke-width="1.4" stroke-linecap="round"/></svg>
                                </span>
                                <input type="password" name="newPassword" placeholder="New password" minlength="8" required>
                            </div>
                        </div>
                        <div class="profile-field">
                            <label class="field-label">Confirm Password</label>
                            <div class="input-group">
                                <span class="input-icon">
                                    <svg viewBox="0 0 16 16" fill="none" class="icon-xs"><rect x="3" y="7" width="10" height="7" rx="1.5" stroke="#888" stroke-width="1.4"/><path d="M5 7V5a3 3 0 016 0v2" stroke="#888" stroke-width="1.4" stroke-linecap="round"/></svg>
                                </span>
                                <input type="password" name="confirmPassword" placeholder="Confirm password" minlength="8" required>
                            </div>
                        </div>
                        <button type="submit" class="submit-btn">Change Password</button>
                    </form>
                </div>

            </div><!-- /profile-top-row -->

                <!-- security question -->
                <div class="profile-section-card">
                    <h3 class="compact-card-title compact-card-title-flex">
                        Security Question
                        <% if (hasQuestion) { %>
                        <span class="badge-count badge-sq-set">Set</span>
                        <% } else { %>
                        <span class="badge-count badge-sq-unset">Not set</span>
                        <% } %>
                    </h3>

                    <% if (!hasQuestion) { %>
                    <div class="alert warn-alert warn-alert-sm">
                        Set a security question to enable account recovery.
                    </div>
                    <% } %>

                    <% if (secError != null) { %><div class="alert"><%= secError %></div><% } %>
                    <% if (secSuccess != null) { %><div class="alert success"><%= secSuccess %></div><% } %>

                    <form action="${pageContext.request.contextPath}/profile" method="post">
                        <input type="hidden" name="action" value="updateSecurity">
                        <div class="profile-field">
                            <label class="field-label"><%= hasQuestion ? "Change Question" : "Select Question" %></label>
                            <div class="input-group select-group">
                                <select name="securityQuestion" required class="select-input select-pl">
                                    <option value="" disabled <%= !hasQuestion ? "selected" : "" %>>Choose…</option>
                                    <option value="What was the name of your first pet?"         <%= "What was the name of your first pet?".equals(currentQuestion)         ? "selected" : "" %>>First pet's name?</option>
                                    <option value="What is your mother's maiden name?"            <%= "What is your mother's maiden name?".equals(currentQuestion)            ? "selected" : "" %>>Mother's maiden name?</option>
                                    <option value="What city were you born in?"                   <%= "What city were you born in?".equals(currentQuestion)                   ? "selected" : "" %>>City you were born in?</option>
                                    <option value="What was the name of your primary school?"    <%= "What was the name of your primary school?".equals(currentQuestion)    ? "selected" : "" %>>Primary school name?</option>
                                    <option value="What is your favourite movie?"                 <%= "What is your favourite movie?".equals(currentQuestion)                 ? "selected" : "" %>>Favourite movie?</option>
                                    <option value="What street did you grow up on?"              <%= "What street did you grow up on?".equals(currentQuestion)              ? "selected" : "" %>>Street you grew up on?</option>
                                </select>
                            </div>
                        </div>
                        <div class="profile-field">
                            <label class="field-label"><%= hasQuestion ? "New Answer" : "Your Answer" %></label>
                            <div class="input-group">
                                <span class="input-icon">
                                    <svg viewBox="0 0 16 16" fill="none" class="icon-xs"><path d="M2 4h12M2 7h8M2 10h10" stroke="#888" stroke-width="1.4" stroke-linecap="round"/></svg>
                                </span>
                                <input type="text" name="securityAnswer"
                                       placeholder="<%= hasQuestion ? "New answer" : "Your answer" %>" required>
                            </div>
                        </div>
                        <button type="submit" class="submit-btn">
                            <%= hasQuestion ? "Update Security Q" : "Set Security Q" %>
                        </button>
                    </form>
                </div>

            </div><!-- /profile-sections-stack -->
        </div><!-- /member-card -->

    </main>
</div>

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
