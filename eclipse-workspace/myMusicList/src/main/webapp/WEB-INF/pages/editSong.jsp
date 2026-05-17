<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myMusicList.model.SongModel" %>
<%
    SongModel song = (SongModel) request.getAttribute("song");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Song – MyMusicList</title>
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
        <p class="sidebar-role">Admin Panel</p>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard?tab=songs" class="nav-link active">
                <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><path d="M5 16V7l10-2v9" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/><circle cx="3.5" cy="16" r="2.5" stroke="currentColor" stroke-width="1.5"/><circle cx="13.5" cy="14" r="2.5" stroke="currentColor" stroke-width="1.5"/></svg>
                Songs
            </a>
            <a href="${pageContext.request.contextPath}/admin/dashboard?tab=users" class="nav-link">
                <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><circle cx="8" cy="7" r="3" stroke="currentColor" stroke-width="1.5"/><path d="M2 17c0-2.761 2.686-5 6-5s6 2.239 6 5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/><path d="M14 8a3 3 0 010 6M16 17a4 4 0 000-8" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
                Users
            </a>
        </nav>
        <div class="sidebar-bottom">
            <a href="${pageContext.request.contextPath}/logout" class="nav-link nav-link-logout">
                <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><path d="M7 3H4a1 1 0 00-1 1v12a1 1 0 001 1h3M13 14l3-4-3-4M16 10H7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                Logout
            </a>
        </div>
    </div>

    <!-- main content -->
    <div class="admin-main">
        <div class="admin-section admin-form-section">

            <div class="admin-form-back">
                <a href="${pageContext.request.contextPath}/admin/dashboard?tab=songs" class="back-link">
                    <svg viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M10 12L6 8l4-4" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    Back to Songs
                </a>
            </div>

            <div class="admin-form-header">
                <div class="admin-form-icon-wrap">
                    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M11 4H6a2 2 0 00-2 2v12a2 2 0 002 2h12a2 2 0 002-2v-5M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </div>
                <div>
                    <h1>Edit Song</h1>
                    <p class="admin-form-sub">Edit the song info below</p>
                </div>
            </div>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/admin/songs" method="post" class="admin-form">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" value="<%= song != null ? song.getId() : "" %>">

                <div class="form-field-label">Song Title</div>
                <div class="input-group">
                    <span class="input-icon input-icon-svg">
                        <svg viewBox="0 0 20 20" fill="none"><path d="M4 14V7l8-2v7" stroke="#aaa" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/><circle cx="2.5" cy="14" r="2.5" stroke="#aaa" stroke-width="1.4"/><circle cx="10.5" cy="12" r="2.5" stroke="#aaa" stroke-width="1.4"/></svg>
                    </span>
                    <input type="text" name="title" placeholder="e.g. Bohemian Rhapsody"
                           value="<%= song != null ? song.getTitle() : "" %>" required>
                </div>

                <div class="form-field-label">Artist Name</div>
                <div class="input-group">
                    <span class="input-icon input-icon-svg">
                        <svg viewBox="0 0 20 20" fill="none"><circle cx="10" cy="7" r="3.5" stroke="#aaa" stroke-width="1.4"/><path d="M3 17c0-3.314 3.134-6 7-6s7 2.686 7 6" stroke="#aaa" stroke-width="1.4" stroke-linecap="round"/></svg>
                    </span>
                    <input type="text" name="artist" placeholder="e.g. Queen"
                           value="<%= song != null ? song.getArtist() : "" %>" required>
                </div>

                <div class="form-field-label">Genre</div>
                <div class="input-group">
                    <span class="input-icon input-icon-svg">
                        <svg viewBox="0 0 20 20" fill="none"><path d="M3 5h14M3 10h14M3 15h8" stroke="#aaa" stroke-width="1.4" stroke-linecap="round"/></svg>
                    </span>
                    <input type="text" name="genre" placeholder="e.g. Rock"
                           value="<%= song != null ? song.getGenre() : "" %>" required>
                </div>

                <div class="admin-form-actions">
                    <button type="submit" class="btn-primary-full btn-form-submit">Save Changes</button>
                    <a href="${pageContext.request.contextPath}/admin/dashboard?tab=songs" class="btn-secondary-outline">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>
