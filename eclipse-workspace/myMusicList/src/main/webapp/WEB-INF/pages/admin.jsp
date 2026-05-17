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
    String songError   = request.getParameter("songError");
    String userSuccess = request.getParameter("userSuccess");
    String userError   = request.getParameter("userError");
    if (search == null) search = "";
    if (sort   == null) sort   = "title";
    if (order  == null) order  = "asc";
    if (activeTab == null) activeTab = "songs";
    String nextOrder = "asc".equals(order) ? "desc" : "asc";
    String orderIcon = "asc".equals(order) ? "&#8593;" : "&#8595;";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard – MyMusicList</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body class="admin-body">
<!-- mobile top bar -->
<div class="mobile-topbar">
    <div class="mobile-brand">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
            <path d="M9 18V5l12-2v13" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <circle cx="6" cy="18" r="3" stroke="white" stroke-width="2"/>
            <circle cx="18" cy="16" r="3" stroke="white" stroke-width="2"/>
        </svg>
        <span>MyMusicList Admin</span>
    </div>
    <button class="hamburger-btn" onclick="toggleSidebar()" aria-label="Menu">
        <span></span><span></span><span></span>
    </button>
</div>
<div class="sidebar-overlay" id="sidebarOverlay" onclick="closeSidebar()"></div>


<div class="admin-wrapper">

    <!-- sidebar -->
    <div class="admin-sidebar" id="mobileSidebar">
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
            <a href="${pageContext.request.contextPath}/admin/dashboard?tab=songs"
               class="nav-link <%= "songs".equals(activeTab) ? "active" : "" %>">
                <svg class="nav-icon" viewBox="0 0 20 20" fill="none"><path d="M5 16V7l10-2v9" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/><circle cx="3.5" cy="16" r="2.5" stroke="currentColor" stroke-width="1.5"/><circle cx="13.5" cy="14" r="2.5" stroke="currentColor" stroke-width="1.5"/></svg>
                Songs
            </a>
            <a href="${pageContext.request.contextPath}/admin/dashboard?tab=users"
               class="nav-link <%= "users".equals(activeTab) ? "active" : "" %>">
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

        <!-- songs tab -->
        <% if ("songs".equals(activeTab)) { %>
        <div class="admin-section">
            <div class="section-header">
                <div class="section-header-left">
                    <h2>Songs</h2>
                    <span class="badge-count"><%= songs != null ? songs.size() : 0 %> total</span>
                </div>
                <a href="${pageContext.request.contextPath}/admin/songs?action=add" class="add-btn">
                    <svg viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8 3v10M3 8h10" stroke="white" stroke-width="1.8" stroke-linecap="round"/></svg>
                    Add Song
                </a>
            </div>

            <%-- BUG 5 FIX: show error banner when song to delete was not found --%>
            <% if ("notfound".equals(songError)) { %>
            <div class="form-error-banner">Song not found — it may have already been deleted.</div>
            <% } %>

            <form action="${pageContext.request.contextPath}/admin/dashboard" method="get" class="admin-search-bar">
                <input type="hidden" name="tab" value="songs">
                <div class="search-input-wrap">
                    <span class="search-icon-svg">
                        <svg viewBox="0 0 20 20" fill="none"><circle cx="9" cy="9" r="5.5" stroke="#aaa" stroke-width="1.5"/><path d="M13 13l3 3" stroke="#aaa" stroke-width="1.5" stroke-linecap="round"/></svg>
                    </span>
                    <input type="text" name="search" value="<%= search %>"
                           placeholder="Search title, artist or genre…" class="search-input">
                </div>
                <div class="sort-wrap">
                    <label>Sort:</label>
                    <select name="sort" onchange="this.form.submit()">
                        <option value="title"  <%= "title" .equals(sort) ? "selected" : "" %>>Title</option>
                        <option value="artist" <%= "artist".equals(sort) ? "selected" : "" %>>Artist</option>
                    </select>
                    <select name="order" onchange="this.form.submit()">
                        <option value="asc"  <%= "asc" .equals(order) ? "selected" : "" %>>&#8593; Asc</option>
                        <option value="desc" <%= "desc".equals(order) ? "selected" : "" %>>&#8595; Desc</option>
                    </select>
                </div>
                <button type="submit" class="search-btn">Search</button>
                <% if (!search.isEmpty()) { %>
                <a href="${pageContext.request.contextPath}/admin/dashboard?tab=songs" class="clear-btn">Clear</a>
                <% } %>
            </form>

            <div class="table-wrap">
                <table class="song-table">
                    <thead>
                        <tr>
                            <th><a href="?tab=songs&sort=title&order=<%= "title".equals(sort) ? nextOrder : "asc" %>&search=<%= search %>" class="sort-link">Title <% if ("title".equals(sort)) { %><%= orderIcon %><% } %></a></th>
                            <th><a href="?tab=songs&sort=artist&order=<%= "artist".equals(sort) ? nextOrder : "asc" %>&search=<%= search %>" class="sort-link">Artist <% if ("artist".equals(sort)) { %><%= orderIcon %><% } %></a></th>
                            <th>Genre</th>
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
                            <td><span class="song-title"><%= song.getTitle() %></span></td>
                            <td class="song-artist"><%= song.getArtist() %></td>
                            <td><span class="genre-tag"><%= song.getGenre() %></span></td>
                            <td>
                                <div class="action-btns">
                                    <a href="${pageContext.request.contextPath}/admin/songs?action=edit&id=<%= song.getId() %>" class="edit-btn">Edit</a>
                                    <a href="#" class="delete-btn" onclick="openDeleteModal('<%= song.getId() %>'); return false;">Delete</a>
                                </div>
                            </td>
                        </tr>
                    <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
        <% } %>

        <!-- users tab -->
        <% if ("users".equals(activeTab)) { %>
        <div class="admin-section">
            <div class="section-header">
                <div class="section-header-left">
                    <h2>Users</h2>
                    <span class="badge-count"><%= users != null ? users.size() : 0 %> total</span>
                </div>
            </div>

            <%-- Feedback banners --%>
            <% if ("deleted".equals(userSuccess)) { %>
            <div class="form-success-banner">User deleted.</div>
            <% } else if ("edited".equals(userSuccess)) { %>
            <div class="form-success-banner">User updated.</div>
            <% } else if ("selfdelete".equals(userError)) { %>
            <div class="form-error-banner">You cannot delete your own account.</div>
            <% } else if ("deletefail".equals(userError)) { %>
            <div class="form-error-banner">Couldn't delete user — something went wrong.</div>
            <% } else if ("notfound".equals(userError)) { %>
            <div class="form-error-banner">User not found.</div>
            <% } %>

            <form action="${pageContext.request.contextPath}/admin/dashboard" method="get" class="admin-search-bar">
                <input type="hidden" name="tab" value="users">
                <div class="search-input-wrap">
                    <span class="search-icon-svg">
                        <svg viewBox="0 0 20 20" fill="none"><circle cx="9" cy="9" r="5.5" stroke="#aaa" stroke-width="1.5"/><path d="M13 13l3 3" stroke="#aaa" stroke-width="1.5" stroke-linecap="round"/></svg>
                    </span>
                    <input type="text" name="search" value="<%= search %>"
                           placeholder="Search name, email or role…" class="search-input">
                </div>
                <div class="sort-wrap">
                    <label>Sort:</label>
                    <select name="sort" onchange="this.form.submit()">
                        <option value="name"  <%= "name" .equals(sort) ? "selected" : "" %>>Name</option>
                        <option value="email" <%= "email".equals(sort) ? "selected" : "" %>>Email</option>
                    </select>
                    <select name="order" onchange="this.form.submit()">
                        <option value="asc"  <%= "asc" .equals(order) ? "selected" : "" %>>&#8593; Asc</option>
                        <option value="desc" <%= "desc".equals(order) ? "selected" : "" %>>&#8595; Desc</option>
                    </select>
                </div>
                <button type="submit" class="search-btn">Search</button>
                <% if (!search.isEmpty()) { %>
                <a href="${pageContext.request.contextPath}/admin/dashboard?tab=users" class="clear-btn">Clear</a>
                <% } %>
            </form>

            <div class="table-wrap">
                <table class="song-table">
                    <thead>
                        <tr>
                            <th><a href="?tab=users&sort=name&order=<%= "name".equals(sort) ? nextOrder : "asc" %>&search=<%= search %>" class="sort-link">Name <% if ("name".equals(sort)) { %><%= orderIcon %><% } %></a></th>
                            <th><a href="?tab=users&sort=email&order=<%= "email".equals(sort) ? nextOrder : "asc" %>&search=<%= search %>" class="sort-link">Email <% if ("email".equals(sort)) { %><%= orderIcon %><% } %></a></th>
                            <th>Role</th>
                            <th>Security Question</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (users == null || users.isEmpty()) { %>
                        <tr><td colspan="5" class="empty-cell">
                            <% if (!search.isEmpty()) { %>No users match "<%= search %>".<% } else { %>No users found.<% } %>
                        </td></tr>
                    <% } else {
                           for (UserModel u : users) {
                               boolean isSelf = (u.getId() == admin.getId());
                    %>
                        <tr>
                            <td><span class="song-title"><%= u.getName() %></span></td>
                            <td class="song-artist"><%= u.getEmail() %></td>
                            <td><span class="role-tag <%= "admin".equals(u.getRole()) ? "role-admin" : "role-user" %>"><%= u.getRole() %></span></td>
                            <td class="sq-cell">
                                <% if (u.getSecurityQuestion() != null && !u.getSecurityQuestion().isEmpty()) { %>
                                    <span class="sq-set">Set</span>
                                    <span class="sq-text-small"><%= u.getSecurityQuestion() %></span>
                                <% } else { %>
                                    <span class="sq-notset">Not set</span>
                                <% } %>
                            </td>
                            <td>
                                <div class="action-btns">
                                    <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=<%= u.getId() %>" class="edit-btn">Edit</a>
                                    <% if (!isSelf) { %>
                                    <a href="#" class="delete-btn"
                                       onclick="openDeleteUserModal('<%= u.getId() %>', '<%= u.getName().replace("'", "\\'") %>'); return false;">Delete</a>
                                    <% } else { %>
                                    <span class="delete-btn-disabled" title="Cannot delete your own account">Delete</span>
                                    <% } %>
                                </div>
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

<!-- song action modals -->
<% if ("added".equals(songSuccess)) { %>
<div class="modal-overlay show" id="songModal">
    <div class="modal-box">
        <div class="modal-icon-wrap modal-icon-success">
            <svg viewBox="0 0 24 24" fill="none"><path d="M5 13l4 4L19 7" stroke="white" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/></svg>
        </div>
        <h3>Song Added</h3><p>Song is now in the library.</p>
        <button class="modal-ok-btn" onclick="document.getElementById('songModal').classList.remove('show')">Done</button>
    </div>
</div>
<% } else if ("edited".equals(songSuccess)) { %>
<div class="modal-overlay show" id="songModal">
    <div class="modal-box">
        <div class="modal-icon-wrap modal-icon-info">
            <svg viewBox="0 0 24 24" fill="none"><path d="M11 4H6a2 2 0 00-2 2v12a2 2 0 002 2h12a2 2 0 002-2v-5M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
        </div>
        <h3>Song Updated</h3><p>Changes saved.</p>
        <button class="modal-ok-btn" onclick="document.getElementById('songModal').classList.remove('show')">Done</button>
    </div>
</div>
<% } else if ("deleted".equals(songSuccess)) { %>
<div class="modal-overlay show" id="songModal">
    <div class="modal-box">
        <div class="modal-icon-wrap modal-icon-danger">
            <svg viewBox="0 0 24 24" fill="none"><path d="M3 6h18M8 6V4h8v2M19 6l-1 14H6L5 6" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
        </div>
        <h3>Song Deleted</h3><p>Song removed from the library.</p>
        <button class="modal-ok-btn" onclick="document.getElementById('songModal').classList.remove('show')">Done</button>
    </div>
</div>
<% } %>

<!-- logout modal -->
<div class="logout-modal-overlay" id="logoutModal">
    <div class="logout-modal-box">
        <div class="modal-icon-wrap">
            <svg viewBox="0 0 24 24" fill="none"><path d="M9 3H5a2 2 0 00-2 2v14a2 2 0 002 2h4M16 17l5-5-5-5M21 12H9" stroke="#667eea" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
        </div>
        <h3>Sign out</h3>
        <p>Sign out of MyMusicList?</p>
        <div class="logout-modal-actions">
            <button class="logout-cancel-btn"
                    onclick="document.getElementById('logoutModal').classList.remove('show')">Cancel</button>
            <a href="${pageContext.request.contextPath}/logout">
                <button class="logout-confirm-btn">Yes, Sign out</button>
            </a>
        </div>
    </div>
</div>

<!-- delete song modal — uses POST so it can't be triggered by visiting a URL -->
<div class="logout-modal-overlay" id="deleteModal">
    <div class="logout-modal-box">
        <div class="modal-icon-wrap modal-icon-danger">
            <svg viewBox="0 0 24 24" fill="none"><path d="M3 6h18M8 6V4h8v2M19 6l-1 14H6L5 6" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
        </div>
        <h3>Delete Song</h3>
        <p>Delete this song? This can't be undone.</p>
        <div class="logout-modal-actions">
            <button class="logout-cancel-btn"
                    onclick="document.getElementById('deleteModal').classList.remove('show')">Cancel</button>
            <form id="deleteSongForm" method="post"
                  action="${pageContext.request.contextPath}/admin/songs" class="form-inline">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id"     id="deleteSongId" value="">
                <button type="submit" class="logout-confirm-btn">Yes, Delete</button>
            </form>
        </div>
    </div>
</div>

<!-- delete user modal -->
<div class="logout-modal-overlay" id="deleteUserModal">
    <div class="logout-modal-box">
        <div class="modal-icon-wrap modal-icon-danger">
            <svg viewBox="0 0 24 24" fill="none"><path d="M3 6h18M8 6V4h8v2M19 6l-1 14H6L5 6" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
        </div>
        <h3>Delete User</h3>
        <p id="deleteUserMsg">Delete this user? This can't be undone.</p>
        <div class="logout-modal-actions">
            <button class="logout-cancel-btn"
                    onclick="document.getElementById('deleteUserModal').classList.remove('show')">Cancel</button>
            <form id="deleteUserForm" method="post"
                  action="${pageContext.request.contextPath}/admin/users" class="form-inline">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id"     id="deleteUserId" value="">
                <button type="submit" class="logout-confirm-btn">Yes, Delete</button>
            </form>
        </div>
    </div>
</div>

<script>

function openDeleteModal(id) {
    document.getElementById('deleteModal').classList.add('show');
    document.getElementById('deleteSongId').value = id;
}

function openDeleteUserModal(id, name) {
    document.getElementById('deleteUserModal').classList.add('show');
    document.getElementById('deleteUserId').value = id;
    document.getElementById('deleteUserMsg').textContent =
        'Delete "' + name + '"? This can\'t be undone.';
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
