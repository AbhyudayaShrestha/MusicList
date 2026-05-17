<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myMusicList.model.UserModel" %>
<%@ page import="com.myMusicList.model.SongModel" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
    UserModel user = (UserModel) session.getAttribute("loggedUser");

    // Loaded from DB by RecentlyPlayedServlet (most-recent first / LIFO stack order)
    @SuppressWarnings("unchecked")
    List<SongModel> recentList = (List<SongModel>) request.getAttribute("recentList");
    if (recentList == null) recentList = new ArrayList<>();

    request.setAttribute("activeNav", "recentlyPlayed");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recently Played – MyMusicList</title>
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
        <a href="${pageContext.request.contextPath}/recentlyPlayed" class="nav-link active">
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

        <!-- summary card -->
        <div class="rp-top-card">
    <div class="rp-top-text">
        <h2>Recently Played</h2>
    </div>

    <div class="rp-top-meta">
        <div class="rp-top-count"><%= recentList.size() %></div>
        <div class="rp-top-label">tracks played</div>
    </div>
</div>

        <div class="member-card">
            <div class="card-header">
                <div class="card-header-left">
                    <h2>History</h2>
                    <span class="badge-count"><%= recentList.size() %> songs</span>
                </div>
                <div class="rp-action-row">
                    <a href="${pageContext.request.contextPath}/queue" class="add-btn add-btn-sm">
                        <svg viewBox="0 0 16 16" fill="none" class="icon-sm">
                            <path d="M2 4h12M2 8h9M2 12h6" stroke="white" stroke-width="1.8" stroke-linecap="round"/>
                            <circle cx="13" cy="12" r="2.5" stroke="white" stroke-width="1.5"/>
                        </svg>
                        Go to Queue
                    </a>
                    <% if (!recentList.isEmpty()) { %>
                    <form action="${pageContext.request.contextPath}/recentlyPlayed" method="post">
                        <input type="hidden" name="action" value="clear">
                        <button type="submit" class="clear-history-btn">Clear History</button>
                    </form>
                    <% } %>
                </div>
            </div>

            <% if (recentList.isEmpty()) { %>
            <div class="empty-state">
    <p>No songs played.</p>
</div>
            <% } else { %>
            <div class="table-wrap">
                <table class="song-table">
                    <thead>
                        <tr>
                            <th class="th-num">#</th>
                            <th>Title</th>
                            <th>Artist</th>
                            <th>Genre</th>
                            <th>Add to Queue</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        int rIdx = 0;
                        for (SongModel rs : recentList) {
                            rIdx++;
                            String rankClass = rIdx == 1 ? "top1" : rIdx == 2 ? "top2" : rIdx == 3 ? "top3" : "";
                    %>
                    <tr>
                        <td class="rp-row-num">
                            <span class="rp-rank-badge <%= rankClass %>"><%= rIdx %></span>
                        </td>
                        <td>
                            <span class="song-title"><%= rs.getTitle() %></span>
                            <% if (rIdx == 1) { %><span class="rp-label rp-label-ml">latest</span><% } %>
                        </td>
                        <td class="song-artist"><%= rs.getArtist() %></td>
                        <td><span class="genre-tag"><%= rs.getGenre() %></span></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/queue" method="post">
                                <input type="hidden" name="action"  value="add">
                                <input type="hidden" name="songId"  value="<%= rs.getId() %>">
                                <button type="submit" class="add-to-queue-mini">+ Queue</button>
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
