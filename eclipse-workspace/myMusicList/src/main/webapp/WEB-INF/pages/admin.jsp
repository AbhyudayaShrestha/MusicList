<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myMusicList.model.UserModel" %>
<%@ page import="com.myMusicList.model.SongModel" %>
<%@ page import="java.util.List" %>
<%
    UserModel admin  = (UserModel)      session.getAttribute("loggedUser");
    List<SongModel> songs = (List<SongModel>) request.getAttribute("songs");
    List<UserModel> users = (List<UserModel>) request.getAttribute("users");
    String activeTab = (String) request.getAttribute("activeTab");
    String search    = (String) request.getAttribute("search");
    String sort      = (String) request.getAttribute("sort");
    String order     = (String) request.getAttribute("order");
    String songSuccess = request.getParameter("songSuccess");
    if (search == null) search = "";
    if (sort   == null) sort   = "title";
    if (order  == null) order  = "asc";
    if (activeTab == null) activeTab = "songs";

    // For sort header links: clicking the same column toggles asc/desc
    String nextOrder = "asc".equals(order) ? "desc" : "asc";
    String orderIcon = "asc".equals(order) ? "↑" : "↓";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard – MyMusicList</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-body">
<div class="admin-wrapper">

    <!-- ── Sidebar ───────────────────────────────────────────────── -->
    <div class="admin-sidebar">
        <div class="sidebar-logo">🎵 MyMusicList</div>
        <p class="sidebar-role">Admin Panel · <%= admin.getName() %></p>

        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard?tab=songs"
               class="nav-link <%= "songs".equals(activeTab) ? "active" : "" %>">🎵 Songs</a>
            <a href="${pageContext.request.contextPath}/admin/dashboard?tab=users"
               class="nav-link <%= "users".equals(activeTab) ? "active" : "" %>">👤 Users</a>
        </nav>

        <div class="sidebar-bottom">
            <%-- Same logout style as member sidebar --%>
            <a href="#" class="nav-link logout-link"
               onclick="document.getElementById('logoutModal').classList.add('show'); return false;">
               🚪 Logout
            </a>
        </div>
    </div>

    <!-- ── Main ──────────────────────────────────────────────────── -->
    <div class="admin-main">

        <!-- ════ SONGS TAB ════════════════════════════════════════ -->
        <% if ("songs".equals(activeTab)) { %>
        <div class="admin-section">
            <div class="section-header">
                <h2>🎵 Songs</h2>
                <a href="${pageContext.request.contextPath}/admin/songs?action=add" class="add-btn">+ Add Song</a>
            </div>

            <!-- Search + Sort bar -->
            <form action="${pageContext.request.contextPath}/admin/dashboard" method="get" class="admin-search-bar">
                <input type="hidden" name="tab" value="songs">
                <div class="search-input-wrap">
                    <span class="search-icon">🔍</span>
                    <input type="text" name="search" value="<%= search %>"
                           placeholder="Search title, artist or genre…" class="search-input">
                </div>
                <div class="sort-wrap">
                    <label>Sort:</label>
                    <select name="sort" onchange="this.form.submit()">
                        <option value="title"  <%= "title" .equals(sort) ? "selected" : "" %>>Title</option>
                        <option value="artist" <%= "artist".equals(sort) ? "selected" : "" %>>Artist</option>
                        <option value="genre"  <%= "genre" .equals(sort) ? "selected" : "" %>>Genre</option>
                    </select>
                    <select name="order" onchange="this.form.submit()">
                        <option value="asc"  <%= "asc" .equals(order) ? "selected" : "" %>>↑ Asc</option>
                        <option value="desc" <%= "desc".equals(order) ? "selected" : "" %>>↓ Desc</option>
                    </select>
                </div>
                <button type="submit" class="search-btn">Search</button>
                <% if (!search.isEmpty()) { %>
                <a href="${pageContext.request.contextPath}/admin/dashboard?tab=songs" class="clear-btn">✕ Clear</a>
                <% } %>
            </form>

            <div class="table-wrap">
            <table class="song-table">
                <thead>
                    <tr>
                        <%-- No # column --%>
                        <th>
                            <a href="?tab=songs&sort=title&order=<%= "title".equals(sort) ? nextOrder : "asc" %>&search=<%= search %>" class="sort-link">
                                Title <%= "title".equals(sort) ? orderIcon : "" %>
                            </a>
                        </th>
                        <th>
                            <a href="?tab=songs&sort=artist&order=<%= "artist".equals(sort) ? nextOrder : "asc" %>&search=<%= search %>" class="sort-link">
                                Artist <%= "artist".equals(sort) ? orderIcon : "" %>
                            </a>
                        </th>
                        <th>
                            <a href="?tab=songs&sort=genre&order=<%= "genre".equals(sort) ? nextOrder : "asc" %>&search=<%= search %>" class="sort-link">
                                Genre <%= "genre".equals(sort) ? orderIcon : "" %>
                            </a>
                        </th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% if (songs == null || songs.isEmpty()) { %>
                    <tr><td colspan="4" class="empty-cell">
                        <% if (!search.isEmpty()) { %>No songs match "<%= search %>".<% } else { %>No songs yet.<% } %>
                    </td></tr>
                <% } else { for (SongModel song : songs) { %>
                    <tr>
                        <td><strong><%= song.getTitle() %></strong></td>
                        <td><%= song.getArtist() %></td>
                        <td><span class="genre-tag"><%= song.getGenre() %></span></td>
                        <td class="action-btns">
                            <a href="${pageContext.request.contextPath}/admin/songs?action=edit&id=<%= song.getId() %>" class="edit-btn">Edit</a>
                            <a href="#" class="delete-btn" onclick="openDeleteModal('<%= song.getId() %>'); return false;">Delete</a>
                        </td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
            </div>
        </div>
        <% } %>

        <!-- ════ USERS TAB ════════════════════════════════════════ -->
        <% if ("users".equals(activeTab)) { %>
        <div class="admin-section">
            <div class="section-header">
                <h2>👤 Users</h2>
                <span class="badge-count"><%= users != null ? users.size() : 0 %> users</span>
            </div>

            <!-- Search + Sort bar -->
            <form action="${pageContext.request.contextPath}/admin/dashboard" method="get" class="admin-search-bar">
                <input type="hidden" name="tab" value="users">
                <div class="search-input-wrap">
                    <span class="search-icon">🔍</span>
                    <input type="text" name="search" value="<%= search %>"
                           placeholder="Search name, email or role…" class="search-input">
                </div>
                <div class="sort-wrap">
                    <label>Sort:</label>
                    <select name="sort" onchange="this.form.submit()">
                        <option value="name"  <%= "name" .equals(sort) ? "selected" : "" %>>Name</option>
                        <option value="email" <%= "email".equals(sort) ? "selected" : "" %>>Email</option>
                        <option value="role"  <%= "role" .equals(sort) ? "selected" : "" %>>Role</option>
                    </select>
                    <select name="order" onchange="this.form.submit()">
                        <option value="asc"  <%= "asc" .equals(order) ? "selected" : "" %>>↑ Asc</option>
                        <option value="desc" <%= "desc".equals(order) ? "selected" : "" %>>↓ Desc</option>
                    </select>
                </div>
                <button type="submit" class="search-btn">Search</button>
                <% if (!search.isEmpty()) { %>
                <a href="${pageContext.request.contextPath}/admin/dashboard?tab=users" class="clear-btn">✕ Clear</a>
                <% } %>
            </form>

            <div class="table-wrap">
            <table class="song-table">
                <thead>
                    <tr>
                        <%-- No # column --%>
                        <th>
                            <a href="?tab=users&sort=name&order=<%= "name".equals(sort) ? nextOrder : "asc" %>&search=<%= search %>" class="sort-link">
                                Name <%= "name".equals(sort) ? orderIcon : "" %>
                            </a>
                        </th>
                        <th>
                            <a href="?tab=users&sort=email&order=<%= "email".equals(sort) ? nextOrder : "asc" %>&search=<%= search %>" class="sort-link">
                                Email <%= "email".equals(sort) ? orderIcon : "" %>
                            </a>
                        </th>
                        <th>
                            <a href="?tab=users&sort=role&order=<%= "role".equals(sort) ? nextOrder : "asc" %>&search=<%= search %>" class="sort-link">
                                Role <%= "role".equals(sort) ? orderIcon : "" %>
                            </a>
                        </th>
                        <th>Security Question</th>
                    </tr>
                </thead>
                <tbody>
                <% if (users == null || users.isEmpty()) { %>
                    <tr><td colspan="4" class="empty-cell">
                        <% if (!search.isEmpty()) { %>No users match "<%= search %>".<% } else { %>No users found.<% } %>
                    </td></tr>
                <% } else { for (UserModel u : users) { %>
                    <tr>
                        <td><strong><%= u.getName() %></strong></td>
                        <td><%= u.getEmail() %></td>
                        <td><span class="role-tag <%= "admin".equals(u.getRole()) ? "role-admin" : "role-user" %>"><%= u.getRole() %></span></td>
                        <td class="sq-cell">
                            <% if (u.getSecurityQuestion() != null && !u.getSecurityQuestion().isEmpty()) { %>
                                <span class="sq-set">✅ Set</span>
                                <span class="sq-text-small"><%= u.getSecurityQuestion() %></span>
                            <% } else { %>
                                <span class="sq-notset">⚠ Not set</span>
                            <% } %>
                        </td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
            </div>
        </div>
        <% } %>

    </div><!-- /admin-main -->
</div><!-- /admin-wrapper -->

<!-- Song action modals -->
<% if ("added".equals(songSuccess)) { %>
<div class="modal-overlay show" id="songModal">
    <div class="modal-box"><div class="modal-icon">🎵</div><h3>Song Added!</h3><p>The song was added successfully.</p>
    <button class="modal-ok-btn" onclick="document.getElementById('songModal').classList.remove('show')">OK</button></div>
</div>
<% } else if ("edited".equals(songSuccess)) { %>
<div class="modal-overlay show" id="songModal">
    <div class="modal-box"><div class="modal-icon">✏️</div><h3>Song Updated!</h3><p>The song was updated successfully.</p>
    <button class="modal-ok-btn" onclick="document.getElementById('songModal').classList.remove('show')">OK</button></div>
</div>
<% } else if ("deleted".equals(songSuccess)) { %>
<div class="modal-overlay show" id="songModal">
    <div class="modal-box"><div class="modal-icon">🗑️</div><h3>Song Deleted!</h3><p>The song was removed successfully.</p>
    <button class="modal-ok-btn" onclick="document.getElementById('songModal').classList.remove('show')">OK</button></div>
</div>
<% } %>

<!-- Logout modal — same as member pages -->
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

<!-- Delete confirm modal -->
<div class="logout-modal-overlay" id="deleteModal">
    <div class="logout-modal-box">
        <div class="modal-icon">🗑️</div>
        <h3>Delete Song</h3>
        <p>Are you sure you want to delete this song?</p>
        <div class="logout-modal-actions">
            <button class="logout-cancel-btn"
                    onclick="document.getElementById('deleteModal').classList.remove('show')">Cancel</button>
            <a id="confirmDeleteLink">
                <button class="logout-confirm-btn">Yes, Delete</button>
            </a>
        </div>
    </div>
</div>

<script>
function openDeleteModal(id) {
    document.getElementById('deleteModal').classList.add('show');
    document.getElementById('confirmDeleteLink').href =
        '${pageContext.request.contextPath}/admin/songs?action=delete&id=' + id;
}
</script>
</body>
</html>
