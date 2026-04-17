<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myMusicList.model.UserModel" %>
<%@ page import="com.myMusicList.model.SongModel" %>

<%
    SongModel song = (SongModel) request.getAttribute("song");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Song – MyMusicList</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-body">
<div class="admin-wrapper">

    <!-- Sidebar -->
    <div class="admin-sidebar">
        <div class="sidebar-logo">🎵 MyMusicList</div>
        <p class="sidebar-role">Admin Panel</p>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard?tab=songs" class="nav-link active">🎵 Songs</a>
            <a href="${pageContext.request.contextPath}/admin/dashboard?tab=users" class="nav-link">👤 Users</a>
        </nav>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
    </div>

    <!-- Main Content -->
    <div class="admin-main">
        <div class="admin-header">
            <h1>Edit Song</h1>
            <p class="subtitle">Update the song details below</p>
        </div>

        <div class="admin-section">
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/admin/songs" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" value="<%= song.getId() %>">

                <div class="input-group">
                    <span class="input-icon">🎵</span>
                    <input type="text" name="title" value="<%= song.getTitle() %>" required>
                </div>
                <div class="input-group">
                    <span class="input-icon">🎤</span>
                    <input type="text" name="artist" value="<%= song.getArtist() %>" required>
                </div>
                <div class="input-group">
                    <span class="input-icon">🎸</span>
                    <input type="text" name="genre" value="<%= song.getGenre() %>" required>
                </div>

                <div class="form-actions">
                    <button type="submit">Update Song</button>
                    <a href="${pageContext.request.contextPath}/admin/dashboard?tab=songs" class="cancel-btn">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>