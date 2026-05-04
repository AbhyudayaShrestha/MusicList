<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myMusicList.model.UserModel" %>
<%
    UserModel user     = (UserModel) session.getAttribute("loggedUser");
    UserModel fullUser = (UserModel) request.getAttribute("fullUser");
    // fullUser has security_question; fall back to session user if null
    if (fullUser == null) fullUser = user;

    String profileError   = (String) request.getAttribute("profileError");
    String profileSuccess = (String) request.getAttribute("profileSuccess");
    String pwError        = (String) request.getAttribute("pwError");
    String pwSuccess      = (String) request.getAttribute("pwSuccess");
    String secError       = (String) request.getAttribute("secError");
    String secSuccess     = (String) request.getAttribute("secSuccess");

    String currentQuestion = fullUser.getSecurityQuestion();
    boolean hasQuestion    = currentQuestion != null && !currentQuestion.trim().isEmpty();
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile – MyMusicList</title>
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
            <a href="${pageContext.request.contextPath}/profile"    class="nav-link active">👤 My Profile</a>
            <a href="${pageContext.request.contextPath}/about"      class="nav-link">ℹ️ About</a>
            <a href="${pageContext.request.contextPath}/contact"    class="nav-link">📬 Contact</a>
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

        <!-- Row 1: Profile info + Change password -->
        <div class="profile-grid">

            <!-- Card: Update Name -->
            <div class="member-card">
                <div class="card-header"><h2>👤 My Profile</h2></div>

                <% if (profileError != null) { %><div class="alert"><%= profileError %></div><% } %>
                <% if (profileSuccess != null) { %><div class="alert success"><%= profileSuccess %></div><% } %>

                <form action="${pageContext.request.contextPath}/profile" method="post">
                    <input type="hidden" name="action" value="updateProfile">
                    <div class="profile-field">
                        <label class="field-label">Full Name</label>
                        <div class="input-group">
                            <span class="input-icon">👤</span>
                            <input type="text" name="name" value="<%= user.getName() %>" required>
                        </div>
                    </div>
                    <div class="profile-field">
                        <label class="field-label">Email <span class="field-hint">(read-only)</span></label>
                        <div class="input-group">
                            <span class="input-icon">✉</span>
                            <input type="email" value="<%= user.getEmail() %>" disabled class="input-disabled">
                        </div>
                    </div>
                    <div class="profile-field">
                        <label class="field-label">Role</label>
                        <div class="input-group">
                            <span class="input-icon">🏷</span>
                            <input type="text" value="<%= user.getRole() %>" disabled class="input-disabled">
                        </div>
                    </div>
                    <button type="submit" class="submit-btn">Save Changes</button>
                </form>
            </div>

            <!-- Card: Change Password -->
            <div class="member-card">
                <div class="card-header"><h2>🔒 Change Password</h2></div>

                <% if (pwError != null) { %><div class="alert"><%= pwError %></div><% } %>
                <% if (pwSuccess != null) { %><div class="alert success"><%= pwSuccess %></div><% } %>

                <form action="${pageContext.request.contextPath}/profile" method="post">
                    <input type="hidden" name="action" value="changePassword">
                    <div class="profile-field">
                        <label class="field-label">Current Password</label>
                        <div class="input-group">
                            <span class="input-icon">🔑</span>
                            <input type="password" name="oldPassword" placeholder="Current password" required>
                        </div>
                    </div>
                    <div class="profile-field">
                        <label class="field-label">New Password <span class="field-hint">(min 8 chars)</span></label>
                        <div class="input-group">
                            <span class="input-icon">🔒</span>
                            <input type="password" name="newPassword" placeholder="New password" minlength="8" required>
                        </div>
                    </div>
                    <div class="profile-field">
                        <label class="field-label">Confirm New Password</label>
                        <div class="input-group">
                            <span class="input-icon">🔒</span>
                            <input type="password" name="confirmPassword" placeholder="Confirm password" minlength="8" required>
                        </div>
                    </div>
                    <button type="submit" class="submit-btn">Change Password</button>
                </form>
            </div>

        </div><!-- /profile-grid -->

        <!-- Row 2: Security Question (full width) -->
        <div class="member-card">
            <div class="card-header">
                <h2>🛡 Security Question</h2>
                <% if (hasQuestion) { %>
                <span class="badge-count" style="background:#f0fff4;color:#276749;">✅ Set</span>
                <% } else { %>
                <span class="badge-count" style="background:#fff0f0;color:#cc0000;">⚠ Not set</span>
                <% } %>
            </div>

            <%-- Show current question (the answer is hashed so we can't display it, by design) --%>
            <% if (hasQuestion) { %>
            <div class="security-question-box" style="margin-bottom:20px;">
                <p class="sq-label">Current question:</p>
                <p class="sq-text"><%= currentQuestion %></p>
                <p class="sq-label" style="margin-top:8px;">Answer:</p>
                <p class="sq-text" style="color:#888;font-weight:400;font-size:13px;">
                    Hidden for security. Enter a new answer below to change it.
                </p>
            </div>
            <% } else { %>
            <div class="alert warn-alert" style="margin-bottom:16px;">
                You don't have a security question set up. Add one so you can recover your account if you forget your password.
            </div>
            <% } %>

            <% if (secError != null) { %><div class="alert"><%= secError %></div><% } %>
            <% if (secSuccess != null) { %><div class="alert success"><%= secSuccess %></div><% } %>

            <form action="${pageContext.request.contextPath}/profile" method="post">
                <input type="hidden" name="action" value="updateSecurity">

                <div class="profile-grid" style="gap:16px;">
                    <div class="profile-field">
                        <label class="field-label"><%= hasQuestion ? "Change Question" : "Select a Question" %></label>
                        <div class="input-group select-group">
                            <span class="input-icon">🛡</span>
                            <select name="securityQuestion" required class="select-input">
                                <option value="" disabled <%= !hasQuestion ? "selected" : "" %>>Choose a question…</option>
                                <option value="What was the name of your first pet?"         <%= "What was the name of your first pet?".equals(currentQuestion)         ? "selected" : "" %>>What was the name of your first pet?</option>
                                <option value="What is your mother's maiden name?"            <%= "What is your mother's maiden name?".equals(currentQuestion)            ? "selected" : "" %>>What is your mother's maiden name?</option>
                                <option value="What city were you born in?"                   <%= "What city were you born in?".equals(currentQuestion)                   ? "selected" : "" %>>What city were you born in?</option>
                                <option value="What was the name of your primary school?"    <%= "What was the name of your primary school?".equals(currentQuestion)    ? "selected" : "" %>>What was the name of your primary school?</option>
                                <option value="What is your favourite movie?"                 <%= "What is your favourite movie?".equals(currentQuestion)                 ? "selected" : "" %>>What is your favourite movie?</option>
                                <option value="What street did you grow up on?"              <%= "What street did you grow up on?".equals(currentQuestion)              ? "selected" : "" %>>What street did you grow up on?</option>
                            </select>
                        </div>
                    </div>
                    <div class="profile-field">
                        <label class="field-label"><%= hasQuestion ? "New Answer" : "Your Answer" %></label>
                        <div class="input-group">
                            <span class="input-icon">💬</span>
                            <input type="text" name="securityAnswer"
                                   placeholder="<%= hasQuestion ? "Enter new answer" : "Your answer" %>" required>
                        </div>
                    </div>
                </div>

                <button type="submit" class="submit-btn" style="max-width:280px;">
                    <%= hasQuestion ? "Update Security Question" : "Set Security Question" %>
                </button>
            </form>
        </div>

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
