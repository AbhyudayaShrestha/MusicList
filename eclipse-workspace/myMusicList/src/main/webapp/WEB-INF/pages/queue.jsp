<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myMusicList.model.UserModel" %>
<%@ page import="com.myMusicList.model.SongModel" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%
    UserModel user            = (UserModel) session.getAttribute("loggedUser");
    List<SongModel> allSongs  = (List<SongModel>) request.getAttribute("allSongs");
    LinkedList<SongModel> queue = (LinkedList<SongModel>) session.getAttribute("songQueue");
    String queueMsg           = request.getParameter("queueMsg");
    String search             = (String) request.getAttribute("search");
    if (search == null) search = "";
    if (queue  == null) queue  = new LinkedList<>();
    boolean hasSearched = !search.isEmpty();
    request.setAttribute("activeNav", "queue");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Queue – MyMusicList</title>
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
        <a href="${pageContext.request.contextPath}/queue" class="nav-link active">
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

    <main class="member-main">

        <% if ("added".equals(queueMsg)) { %>
        <div class="banner success">Song added to queue.</div>
        <% } else if ("removed".equals(queueMsg)) { %>
        <div class="banner info">Song removed from queue.</div>
        <% } else if ("played".equals(queueMsg)) { %>
        <div class="banner success">Song played and moved to Recently Played!</div>
        <% } else if ("cleared".equals(queueMsg)) { %>
        <div class="banner info">Queue cleared.</div>
        <% } else if ("alreadyInQueue".equals(queueMsg)) { %>
        <div class="banner warn">That song is already in the queue.</div>
        <% } %>

        <div class="queue-layout">

            <!-- left: queue panel -->
            <div class="member-card">
                <div class="card-header">
                    <div class="card-header-left">
                        <div class="queue-panel-title">
                            <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                                <path d="M3 5h14M3 10h10M3 15h6" stroke="#667eea" stroke-width="1.6" stroke-linecap="round"/>
                                <circle cx="16" cy="15" r="3" stroke="#667eea" stroke-width="1.4"/>
                                <path d="M15 15l.7.7 1.3-1.4" stroke="#667eea" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                            <h2>Now Playing Queue</h2>
                        </div>
                        <span class="badge-count badge-count-mt"><%= queue.size() %> songs</span>
                    </div>
                    <% if (!queue.isEmpty()) { %>
                    <form action="${pageContext.request.contextPath}/queue" method="post" class="form-inline">
                        <input type="hidden" name="action" value="clear">
                        <button type="submit" class="clear-queue-btn">Clear All</button>
                    </form>
                    <% } %>
                </div>

                <% if (queue.isEmpty()) { %>
                <div class="empty-state">
                    <p>Your queue is empty. Search for songs on the right to add some.</p>
                </div>
                <% } else { %>

                <!-- now playing — first in queue -->
                <%
                    SongModel firstSong = queue.getFirst();
                %>
                <div class="queue-now-playing">
                    <div class="now-playing-icon">
                        <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
                            <path d="M7 13.5V5.5l7-1.5v8" stroke="white" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
                            <circle cx="5" cy="13.5" r="2" stroke="white" stroke-width="1.5"/>
                            <circle cx="12" cy="12" r="2" stroke="white" stroke-width="1.5"/>
                        </svg>
                    </div>
                    <div class="now-playing-info">
                        <div class="now-playing-label">Up Next</div>
                        <div class="now-playing-title"><%= firstSong.getTitle() %></div>
                        <div class="now-playing-artist"><%= firstSong.getArtist() %> &middot; <span class="genre-tag genre-tag-sm"><%= firstSong.getGenre() %></span></div>
                    </div>
                    <form action="${pageContext.request.contextPath}/queue" method="post">
                        <input type="hidden" name="action" value="play">
                        <button type="submit" class="play-btn">
                            <svg width="13" height="13" viewBox="0 0 13 13" fill="none"><path d="M3 2l8 4.5L3 11V2z" fill="white"/></svg>
                            Play
                        </button>
                    </form>
                </div>

                <!-- queue list -->
                <div class="flex-col-gap">
                <%
                    int qIdx = 0;
                    for (SongModel qs : queue) {
                        qIdx++;
                %>
                <div class="queue-list-item">
                    <div class="queue-pos <%= qIdx == 1 ? "first" : "" %>"><%= qIdx %></div>
                    <div class="queue-item-info">
                        <div class="queue-item-title"><%= qs.getTitle() %></div>
                        <div class="queue-item-sub"><%= qs.getArtist() %> &middot; <%= qs.getGenre() %></div>
                    </div>
                    <form action="${pageContext.request.contextPath}/queue" method="post">
                        <input type="hidden" name="action"  value="remove">
                        <input type="hidden" name="songId"  value="<%= qs.getId() %>">
                        <button type="submit" class="btn-dequeue">Remove</button>
                    </form>
                </div>
                <% } %>
                </div>
                <% } %>
            </div>

            <!-- right: search to add songs -->
            <div class="member-card">
                <div class="card-header">
                    <div class="card-header-left">
                        <h2>Add to Queue</h2>
                        <span class="badge-count">Search for songs below</span>
                    </div>
                </div>

                <!-- search bar -->
                <form action="${pageContext.request.contextPath}/queue" method="get" class="search-bar">
                    <div class="search-input-wrap">
                        <span class="search-icon-svg">
                            <svg viewBox="0 0 20 20" fill="none"><circle cx="9" cy="9" r="5.5" stroke="#aaa" stroke-width="1.5"/><path d="M13 13l3 3" stroke="#aaa" stroke-width="1.5" stroke-linecap="round"/></svg>
                        </span>
                        <input type="text" name="search" value="<%= search %>"
                               placeholder="Search songs by title, artist or genre…" class="search-input">
                    </div>
                    <button type="submit" class="search-btn">Search</button>
                    <% if (hasSearched) { %>
                    <a href="${pageContext.request.contextPath}/queue" class="clear-btn">Clear</a>
                    <% } %>
                </form>

                <!-- results shown after search -->
                <% if (!hasSearched) { %>
                <div class="search-hint-state">
                    <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
                        <circle cx="22" cy="22" r="14" stroke="#aaa" stroke-width="2"/>
                        <path d="M32 32l8 8" stroke="#aaa" stroke-width="2" stroke-linecap="round"/>
                        <path d="M18 22v-6l10-2v6" stroke="#aaa" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
                        <circle cx="16" cy="22" r="3" stroke="#aaa" stroke-width="1.8"/>
                        <circle cx="26" cy="20" r="3" stroke="#aaa" stroke-width="1.8"/>
                    </svg>
                    <p>Type a song name or artist to find songs and add them to your queue.</p>
                </div>

                <% } else if (allSongs == null || allSongs.isEmpty()) { %>
                <div class="empty-state">
                    <p>No songs match "<strong><%= search %></strong>".</p>
                </div>

                <% } else { %>
                <%
                    java.util.Set<Integer> queueIds = new java.util.HashSet<>();
                    for (SongModel qs : queue) queueIds.add(qs.getId());
                %>
                <div class="table-wrap">
                    <table class="song-table">
                        <thead>
                            <tr><th>#</th><th>Title</th><th>Artist</th><th>Genre</th><th>Queue</th></tr>
                        </thead>
                        <tbody>
                        <%
                            int i = 1;
                            for (SongModel song : allSongs) {
                                boolean inQueue = queueIds.contains(song.getId());
                        %>
                        <tr>
                            <td class="row-num"><%= i++ %></td>
                            <td><span class="song-title"><%= song.getTitle() %></span></td>
                            <td class="song-artist"><%= song.getArtist() %></td>
                            <td><span class="genre-tag"><%= song.getGenre() %></span></td>
                            <td>
                                <% if (inQueue) { %>
                                <span class="btn-enqueue-disabled">In Queue</span>
                                <% } else { %>
                                <form action="${pageContext.request.contextPath}/queue" method="post">
                                    <input type="hidden" name="action"  value="add">
                                    <input type="hidden" name="songId"  value="<%= song.getId() %>">
                                    <button type="submit" class="btn-enqueue">+ Queue</button>
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

        </div><!-- /queue-layout -->

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
