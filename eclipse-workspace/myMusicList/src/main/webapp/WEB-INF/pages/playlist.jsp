<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myMusicList.model.UserModel" %>
<%@ page import="com.myMusicList.model.PlaylistModel" %>
<%@ page import="com.myMusicList.model.SongModel" %>
<%@ page import="java.util.List" %>
<%
    UserModel user               = (UserModel) session.getAttribute("loggedUser");
    List<PlaylistModel> playlist = (List<PlaylistModel>) request.getAttribute("playlist");
    List<Integer> playlistSongIds = (List<Integer>) request.getAttribute("playlistSongIds");
    List<SongModel> allSongs     = (List<SongModel>) request.getAttribute("allSongs");
    String playlistMsg           = request.getParameter("playlistMsg");
    request.setAttribute("activeNav", "playlist");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Playlist – MyMusicList</title>
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
        <a href="${pageContext.request.contextPath}/playlist" class="nav-link active">
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

    <main class="member-main">

        <%-- Feedback banners --%>
        <% if ("removed".equals(playlistMsg)) { %>
        <div class="banner info">Song removed from your playlist.</div>
        <% } else if ("added".equals(playlistMsg)) { %>
        <div class="banner success">Song added to your playlist.</div>
        <% } %>

        <div class="member-card">
            <div class="card-header">
                <div class="card-header-left">
                    <h2>My Playlist</h2>
                    <span class="badge-count"><%= playlist != null ? playlist.size() : 0 %> songs</span>
                </div>
                <a href="${pageContext.request.contextPath}/queue" class="add-btn">
                    <svg viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M2 4h12M2 8h9M2 12h6" stroke="white" stroke-width="1.8" stroke-linecap="round"/>
                        <circle cx="13" cy="12" r="2.5" stroke="white" stroke-width="1.5"/>
                    </svg>
                    Manage Queue
                </a>
            </div>

            <%-- ── Add Songs from Library ─────────────────────────────── --%>
            <div class="pl-lib-section">
                <h3 class="pl-section-title">Search Library to Add Songs</h3>
                <div class="admin-search-bar pl-search-bar">
                    <div class="search-input-wrap">
                        <span class="search-icon-svg">
                            <svg viewBox="0 0 20 20" fill="none"><circle cx="9" cy="9" r="5.5" stroke="#aaa" stroke-width="1.5"/><path d="M13 13l3 3" stroke="#aaa" stroke-width="1.5" stroke-linecap="round"/></svg>
                        </span>
                        <input type="text" id="librarySearch"
                               placeholder="Search by title, artist or genre…"
                               class="search-input"
                               oninput="filterLibrary(this.value)">
                    </div>
                    <button type="button" class="clear-btn" onclick="clearLibrarySearch()" id="libClearBtn" class="hidden">Clear</button>
                </div>
                <div id="libResults" class="table-wrap hidden">
                    <table class="song-table">
                        <thead><tr><th>#</th><th>Title</th><th>Artist</th><th>Genre</th><th>Action</th></tr></thead>
                        <tbody id="libResultsBody"></tbody>
                    </table>
                    <div id="libNoResults" class="empty-state hidden">
                        <p>No songs match your search.</p>
                    </div>
                </div>
            </div>

            <%-- Embed all library songs as JSON --%>
            <script>
            var ALL_SONGS = [
            <%
                if (allSongs != null) {
                    for (int si = 0; si < allSongs.size(); si++) {
                        com.myMusicList.model.SongModel s = allSongs.get(si);
                        boolean inPl = playlistSongIds != null && playlistSongIds.contains(s.getId());
                        String safeTitle  = s.getTitle().replace("\\","\\\\").replace("\"","\\\"").replace("\r","").replace("\n","");
                        String safeArtist = s.getArtist().replace("\\","\\\\").replace("\"","\\\"").replace("\r","").replace("\n","");
                        String safeGenre  = s.getGenre().replace("\\","\\\\").replace("\"","\\\"").replace("\r","").replace("\n","");
            %>
                {id:<%= s.getId() %>,title:"<%= safeTitle %>",artist:"<%= safeArtist %>",genre:"<%= safeGenre %>",inPlaylist:<%= inPl %>}<%= si < allSongs.size()-1 ? "," : "" %>
            <%
                    }
                }
            %>
            ];
            var CTX = "${pageContext.request.contextPath}";
            </script>

            <%-- ── My Playlist table ──────────────────────────────────── --%>
            <% if (playlist == null || playlist.isEmpty()) { %>
            <div class="empty-state">
                <p>Your playlist is empty. Search the library above to add songs.</p>
            </div>
            <% } else { %>
            <h3 class="pl-section-title">My Playlist</h3>
            <div class="table-wrap">
                <table class="song-table" id="playlistTable">
                    <thead>
                        <tr><th>#</th><th>Title</th><th>Artist</th><th>Genre</th><th>Action</th></tr>
                    </thead>
                    <tbody id="playlistBody">
                    <%
                        int n = 1;
                        for (PlaylistModel entry : playlist) {
                    %>
                    <tr>
                        <td class="row-num"><%= n++ %></td>
                        <td><span class="song-title"><%= entry.getSongTitle() %></span></td>
                        <td class="song-artist"><%= entry.getSongArtist() %></td>
                        <td><span class="genre-tag"><%= entry.getSongGenre() %></span></td>
                        <td>
                            <button type="button" class="btn-remove-playlist"
                                    onclick="openRemoveModal(<%= entry.getSongId() %>)">Remove</button>
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
    <input type="hidden" name="action"   value="remove">
    <input type="hidden" name="songId"   id="removeSongId" value="">
    <input type="hidden" name="redirect" value="playlist">
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

function filterLibrary(query) {
    var q = query.trim().toLowerCase();
    var resultsDiv = document.getElementById('libResults');
    var clearBtn   = document.getElementById('libClearBtn');
    var tbody      = document.getElementById('libResultsBody');
    var noResults  = document.getElementById('libNoResults');

    if (!q) {
        resultsDiv.classList.add('hidden');
        clearBtn.classList.add('hidden');
        return;
    }

    clearBtn.classList.remove('hidden');
    resultsDiv.classList.remove('hidden');

    var matched = ALL_SONGS.filter(function(s) {
        return s.title.toLowerCase().includes(q)
            || s.artist.toLowerCase().includes(q)
            || s.genre.toLowerCase().includes(q);
    });

    if (matched.length === 0) {
        tbody.innerHTML = '';
        noResults.classList.remove('hidden');
        document.querySelector('#libResults table').classList.add('hidden');
        return;
    }

    noResults.classList.add('hidden');
    document.querySelector('#libResults table').classList.remove('hidden');

    tbody.innerHTML = matched.map(function(s, idx) {
        var action = s.inPlaylist
            ? '<span class="genre-tag tag-in-playlist">In Playlist</span>'
            : '<form action="' + CTX + '/playlist" method="post" class="form-inline">' +
              '<input type="hidden" name="action" value="add">' +
              '<input type="hidden" name="songId" value="' + s.id + '">' +
              '<input type="hidden" name="redirect" value="playlist">' +
              '<button type="submit" class="btn-add-playlist">+ Add</button>' +
              '</form>';
        return '<tr>' +
            '<td class="row-num">' + (idx + 1) + '</td>' +
            '<td><span class="song-title">' + escHtml(s.title) + '</span></td>' +
            '<td class="song-artist">' + escHtml(s.artist) + '</td>' +
            '<td><span class="genre-tag">' + escHtml(s.genre) + '</span></td>' +
            '<td>' + action + '</td>' +
            '</tr>';
    }).join('');
}

function escHtml(str) {
    return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

function clearLibrarySearch() {
    document.getElementById('librarySearch').value = '';
    filterLibrary('');
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
