<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myMusicList.model.UserModel" %>
<%
    UserModel admin      = (UserModel) session.getAttribute("loggedUser");
    UserModel targetUser = (UserModel) request.getAttribute("targetUser");
    String errorParam    = request.getParameter("error");

    String errorMsg = null;
    if ("emptyname".equals(errorParam))    errorMsg = "Name cannot be empty.";
    else if ("invalidrole".equals(errorParam)) errorMsg = "Invalid role selected.";
    else if ("selfdemote".equals(errorParam))  errorMsg = "You cannot remove your own admin role.";
    else if ("savefail".equals(errorParam))    errorMsg = "Something went wrong. Please try again.";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User – MyMusicList Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body class="admin-body">

<div class="admin-wrapper">

    <!-- sidebar -->
    <div class="admin-sidebar">
        <div class="sidebar-brand">
            <svg class="sidebar-brand-svg" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 18V5l12-2v13" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <circle cx="6" cy="18" r="3" stroke="white" stroke-width="2"/>
                <circle cx="18" cy="16" r="3" stroke="white" stroke-width="2"/>
            </svg>
            <span>MyMusicList</span>
        </div>
        <p class="sidebar-role">Admin &middot; <%= admin.getName() %></p>

        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard?tab=songs" class="nav-link">
                <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><path d="M5 16V7l10-2v9" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/><circle cx="3.5" cy="16" r="2.5" stroke="currentColor" stroke-width="1.5"/><circle cx="13.5" cy="14" r="2.5" stroke="currentColor" stroke-width="1.5"/></svg>
                Songs
            </a>
            <a href="${pageContext.request.contextPath}/admin/dashboard?tab=users" class="nav-link active">
                <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><circle cx="8" cy="7" r="3" stroke="currentColor" stroke-width="1.5"/><path d="M2 17c0-2.761 2.686-5 6-5s6 2.239 6 5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M14 8a3 3 0 010 6M16 17a4 4 0 000-8" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
                Users
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

    <!-- main -->
    <div class="admin-main">
        <div class="admin-section">

            <div class="section-header">
                <div class="section-header-left">
                    <a href="${pageContext.request.contextPath}/admin/dashboard?tab=users" class="back-link">
                        <svg viewBox="0 0 20 20" fill="none" class="icon-sm-inline">
                            <path d="M13 16l-5-6 5-6" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                        Back to Users
                    </a>
                    <h2 class="mt-3">Edit User</h2>
                </div>
            </div>

            <!-- error banner -->
            <% if (errorMsg != null) { %>
            <div class="form-error-banner"><%= errorMsg %></div>
            <% } %>

            <!-- edit user form -->
            <div class="edit-song-card">
                <form action="${pageContext.request.contextPath}/admin/users" method="post" class="edit-song-form">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id"     value="<%= targetUser.getId() %>">

                    <div class="form-group">
                        <label for="name">Display Name</label>
                        <input type="text" id="name" name="name"
                               value="<%= targetUser.getName() %>"
                               placeholder="Full name" required maxlength="100">
                    </div>

                    <div class="form-group">
                        <label for="email">Email (read-only)</label>
                        <input type="text" id="email" value="<%= targetUser.getEmail() %>" disabled>
                    </div>

                    <div class="form-group">
                        <label for="role">Role</label>
                        <select id="role" name="role">
                            <option value="user"  <%= "user" .equals(targetUser.getRole()) ? "selected" : "" %>>User</option>
                            <option value="admin" <%= "admin".equals(targetUser.getRole()) ? "selected" : "" %>>Admin</option>
                        </select>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/dashboard?tab=users" class="cancel-btn">Cancel</a>
                        <button type="submit" class="save-btn">Save Changes</button>
                    </div>
                </form>
            </div>

        </div>
    </div><!-- /admin-main -->
</div><!-- /admin-wrapper -->

<!-- logout modal -->
<div class="logout-modal-overlay" id="logoutModal">
    <div class="logout-modal-box">
        <div class="modal-icon-wrap">
            <svg viewBox="0 0 24 24" fill="none"><path d="M9 3H5a2 2 0 00-2 2v14a2 2 0 002 2h4M16 17l5-5-5-5M21 12H9" stroke="#667eea" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
        </div>
        <h3>Sign out</h3>
        <p>Are you sure you want to sign out?</p>
        <div class="logout-modal-actions">
            <button class="logout-cancel-btn"
                    onclick="document.getElementById('logoutModal').classList.remove('show')">Cancel</button>
            <a href="${pageContext.request.contextPath}/logout">
                <button class="logout-confirm-btn">Yes, Sign out</button>
            </a>
        </div>
    </div>
</div>

</body>
</html>
x