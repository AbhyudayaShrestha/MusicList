<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myMusicList.model.UserModel" %>
<%@ page import="com.myMusicList.model.SongModel" %>
<%@ page import="java.util.List" %>
<%
    UserModel user        = (UserModel) session.getAttribute("loggedUser");
    List<SongModel> songs = (List<SongModel>) request.getAttribute("songs");
    List<Integer> playlistIds = (List<Integer>) request.getAttribute("playlistIds");
    String search      = (String) request.getAttribute("search");
    String sort        = (String) request.getAttribute("sort");
    String playlistMsg = request.getParameter("playlistMsg");
    if (search == null) search = "";
    if (sort   == null) sort   = "title";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Library – MyMusicList</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="member-page">

<div class="member-wrapper">

    <!-- ── Left Sidebar ──────────────────────────────────────────── -->
    <aside class="member-sidebar">
        <div class="sidebar-logo">🎵 MyMusicList</div>
        <div class="sidebar-greeting">Hi, <strong><%= user.getName() %></strong></div>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/dashboard"  class="nav-link active">📚 Library</a>
            <a href="${pageContext.request.contextPath}/playlist"   class="nav-link">🎧 My Playlist</a>
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

        <%-- Playlist action feedback only — no login success banner --%>
        <% if ("added".equals(playlistMsg)) { %>
        <div class="banner success">🎵 Song added to your playlist!</div>
        <% } else if ("removed".equals(playlistMsg)) { %>
        <div class="banner info">🗑 Song removed from your playlist.</div>
        <% } else if ("already".equals(playlistMsg)) { %>
        <div class="banner warn">⚠ That song is already in your playlist.</div>
        <% } %>

        <!-- Song Library Card -->
        <div class="member-card">
            <div class="card-header">
                <h2>📚 Song Library</h2>
                <span class="badge-count"><%= songs != null ? songs.size() : 0 %> songs</span>
            </div>

            <!-- Search + Sort -->
            <form action="${pageContext.request.contextPath}/dashboard" method="get" class="search-bar">
                <div class="search-input-wrap">
                    <span class="search-icon">🔍</span>
                    <input type="text" name="search" value="<%= search %>"
                           placeholder="Search by title, artist or genre…" class="search-input">
                </div>
                <div class="sort-wrap">
                    <label>Sort by:</label>
                    <select name="sort" onchange="this.form.submit()">
                        <option value="title"  <%= "title" .equals(sort) ? "selected" : "" %>>Title</option>
                        <option value="artist" <%= "artist".equals(sort) ? "selected" : "" %>>Artist</option>
                        <option value="genre"  <%= "genre" .equals(sort) ? "selected" : "" %>>Genre</option>
                    </select>
                </div>
                <button type="submit" class="search-btn">Search</button>
                <% if (!search.isEmpty()) { %>
                <a href="${pageContext.request.contextPath}/dashboard" class="clear-btn">✕ Clear</a>
                <% } %>
            </form>

            <!-- Songs Table -->
            <% if (songs == null || songs.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">🎵</div>
                <p><% if (!search.isEmpty()) { %>No songs match "<strong><%= search %></strong>".<% } else { %>No songs in the library yet.<% } %></p>
            </div>
            <% } else { %>
            <div class="table-wrap">
            <table class="song-table">
                <thead>
                    <tr><th>#</th><th>Title</th><th>Artist</th><th>Genre</th><th>Playlist</th></tr>
                </thead>
                <tbody>
                <%
                    int i = 1;
                    for (SongModel song : songs) {
                        boolean inPl = playlistIds != null && playlistIds.contains(song.getId());
                %>
                <tr class="<%= inPl ? "row-in-playlist" : "" %>">
                    <td><%= i++ %></td>
                    <td><strong><%= song.getTitle() %></strong></td>
                    <td><%= song.getArtist() %></td>
                    <td><span class="genre-tag"><%= song.getGenre() %></span></td>
                    <td>
                        <% if (inPl) { %>
                        <form action="${pageContext.request.contextPath}/playlist" method="post" style="display:inline">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="songId" value="<%= song.getId() %>">
                            <button type="submit" class="btn-remove-playlist">− Remove</button>
                        </form>
                        <% } else { %>
                        <form action="${pageContext.request.contextPath}/playlist" method="post" style="display:inline">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="songId" value="<%= song.getId() %>">
                            <button type="submit" class="btn-add-playlist">+ Add</button>
                        </form>
                        <% } %>
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
