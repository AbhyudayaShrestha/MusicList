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
    String order       = (String) request.getAttribute("order");
    String playlistMsg = request.getParameter("playlistMsg");
    if (search == null) search = "";
    if (sort   == null) sort   = "title";
    if (order  == null) order  = "asc";
    request.setAttribute("activeNav", "library");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library – MyMusicList</title>
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
        <a href="${pageContext.request.contextPath}/dashboard" class="nav-link active">
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

    <!-- main content -->
    <main class="member-main">

        <% if ("added".equals(playlistMsg)) { %>
        <div class="banner success">Added to playlist.</div>
        <% } else if ("removed".equals(playlistMsg)) { %>
        <div class="banner info">Removed from playlist.</div>
        <% } else if ("already".equals(playlistMsg)) { %>
        <div class="banner warn">Already in your playlist.</div>
        <% } %>

        <div class="member-card">
            <div class="card-header">
                <div class="card-header-left">
                    <h2>Song Library</h2>
                    <span class="badge-count"><%= songs != null ? songs.size() : 0 %> songs</span>
                </div>
            </div>

            <!-- search and sort bar -->
            <form action="${pageContext.request.contextPath}/dashboard" method="get" class="search-bar">
                <div class="search-input-wrap">
                    <span class="search-icon-svg">
                        <svg viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <circle cx="9" cy="9" r="5.5" stroke="#aaa" stroke-width="1.5"/>
                            <path d="M13 13l3 3" stroke="#aaa" stroke-width="1.5" stroke-linecap="round"/>
                        </svg>
                    </span>
                    <input type="text" name="search" value="<%= search %>"
                           placeholder="Search by title, artist or genre…" class="search-input">
                </div>
                <div class="sort-wrap">
                    <label>Sort by:</label>
                    <select name="sort" onchange="this.form.submit()">
                        <option value="title"  <%= "title" .equals(sort) ? "selected" : "" %>>Title</option>
                        <option value="artist" <%= "artist".equals(sort) ? "selected" : "" %>>Artist</option>
                    </select>
                </div>
                <div class="sort-wrap">
                    <label>Order:</label>
                    <select name="order" onchange="this.form.submit()">
                        <option value="asc"  <%= "asc" .equals(order) ? "selected" : "" %>>Asc</option>
                        <option value="desc" <%= "desc".equals(order) ? "selected" : "" %>>Desc</option>
                    </select>
                </div>
                <button type="submit" class="search-btn">Search</button>
                <% if (!search.isEmpty()) { %>
                <a href="${pageContext.request.contextPath}/dashboard" class="clear-btn">Clear</a>
                <% } %>
            </form>

            <!-- songs table -->
            <% if (songs == null || songs.isEmpty()) { %>
            <div class="empty-state">
                <svg class="empty-icon-svg" viewBox="0 0 60 60" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <circle cx="30" cy="30" r="28" stroke="#e0e0e0" stroke-width="2"/>
                    <path d="M22 30V18l18-3v12" stroke="#ccc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    <circle cx="19" cy="30" r="4" stroke="#ccc" stroke-width="2"/>
                    <circle cx="37" cy="27" r="4" stroke="#ccc" stroke-width="2"/>
                </svg>
                <p>
                    <% if (!search.isEmpty()) { %>No songs match "<strong><%= search %></strong>".<% } else { %>No songs added yet.<% } %>
                </p>
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
                        <td class="row-num"><%= i++ %></td>
                        <td><span class="song-title"><%= song.getTitle() %></span></td>
                        <td class="song-artist"><%= song.getArtist() %></td>
                        <td><span class="genre-tag"><%= song.getGenre() %></span></td>
                        <td>
                            <% if (inPl) { %>
                            <button type="button" class="btn-remove-playlist"
                                    onclick="openRemoveModal(<%= song.getId() %>)">Remove</button>
                            <% } else { %>
                            <form action="${pageContext.request.contextPath}/playlist" method="post">
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

<!-- hidden form used by the remove modal -->
<form id="removeForm" action="${pageContext.request.contextPath}/playlist" method="post">
    <input type="hidden" name="action" value="remove">
    <input type="hidden" name="songId" id="removeSongId" value="">
</form>

<!-- remove from playlist modal -->
<div class="logout-modal-overlay" id="removeModal">
    <div class="logout-modal-box">
        <div class="modal-icon-wrap">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 18V5l12-2v13" stroke="#667eea" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <circle cx="6" cy="18" r="3" stroke="#667eea" stroke-width="2"/>
                <circle cx="18" cy="16" r="3" stroke="#667eea" stroke-width="2"/>
                <path d="M18 5L6 19" stroke="#e53e3e" stroke-width="2" stroke-linecap="round"/>
            </svg>
        </div>
        <h3>Remove Song</h3>
        <p>Are you sure you want to remove this song from your playlist?</p>
        <div class="logout-modal-actions">
            <button class="logout-cancel-btn"
                    onclick="document.getElementById('removeModal').classList.remove('show')">Cancel</button>
            <button class="logout-confirm-btn"
                    onclick="document.getElementById('removeForm').submit()">Yes, Remove</button>
        </div>
    </div>
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
function openRemoveModal(songId) {
    document.getElementById('removeSongId').value = songId;
    document.getElementById('removeModal').classList.add('show');
}
</script>

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
