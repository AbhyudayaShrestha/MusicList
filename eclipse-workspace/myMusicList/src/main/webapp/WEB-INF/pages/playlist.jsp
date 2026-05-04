<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myMusicList.model.UserModel" %>
<%@ page import="com.myMusicList.model.PlaylistModel" %>
<%@ page import="java.util.List" %>
<%
    UserModel user              = (UserModel) session.getAttribute("loggedUser");
    List<PlaylistModel> playlist = (List<PlaylistModel>) request.getAttribute("playlist");
    String playlistMsg           = request.getParameter("playlistMsg");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Playlist – MyMusicList</title>
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
            <a href="${pageContext.request.contextPath}/playlist"   class="nav-link active">🎧 My Playlist</a>
            <a href="${pageContext.request.contextPath}/profile"    class="nav-link">👤 My Profile</a>
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

        <% if ("removed".equals(playlistMsg)) { %>
        <div class="banner info">🗑 Song removed from your playlist.</div>
        <% } %>

        <div class="member-card">
            <div class="card-header">
                <h2>🎧 My Playlist</h2>
                <span class="badge-count"><%= playlist != null ? playlist.size() : 0 %> songs</span>
            </div>

            <% if (playlist == null || playlist.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">🎧</div>
                <p>Your playlist is empty.<br>
                   Go to <a href="${pageContext.request.contextPath}/dashboard"
                            style="color:#667eea;font-weight:600;">Library</a>
                   and use <strong>+ Add</strong> to build your playlist!</p>
            </div>
            <% } else { %>
            <div class="table-wrap">
            <table class="song-table">
                <thead>
                    <tr><th>#</th><th>Title</th><th>Artist</th><th>Genre</th><th>Action</th></tr>
                </thead>
                <tbody>
                <%
                    int n = 1;
                    for (PlaylistModel entry : playlist) {
                %>
                <tr>
                    <td><%= n++ %></td>
                    <td><strong><%= entry.getSongTitle() %></strong></td>
                    <td><%= entry.getSongArtist() %></td>
                    <td><span class="genre-tag"><%= entry.getSongGenre() %></span></td>
                    <td>
                        <form action="${pageContext.request.contextPath}/playlist" method="post"
                              onsubmit="return confirm('Remove this song from your playlist?')">
                            <input type="hidden" name="action"  value="remove">
                            <input type="hidden" name="songId"  value="<%= entry.getSongId() %>">
                            <input type="hidden" name="redirect" value="playlist">
                            <button type="submit" class="btn-remove-playlist">🗑 Remove</button>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            </div>
            <% } %>
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
