<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myMusicList.model.UserModel" %>
<%@ page import="com.myMusicList.model.SongModel" %>
<%@ page import="java.util.List" %>
<%
    UserModel admin = (UserModel) session.getAttribute("loggedUser");
    List<SongModel> songs = (List<SongModel>) request.getAttribute("songs");
    List<UserModel> users = (List<UserModel>) request.getAttribute("users");
    String songSuccess = request.getParameter("songSuccess");
    String loginSuccessAdmin = request.getParameter("loginSuccess");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard – MyMusicList</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-body">
<div class="admin-wrapper">

    <!-- Sidebar -->
    <div class="admin-sidebar">
        <div class="sidebar-logo">🎵 MyMusicList</div>
        <p class="sidebar-role">Admin Panel</p>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard?tab=songs"
               class="nav-link <%= "songs".equals(request.getAttribute("activeTab")) ? "active" : "" %>">
               🎵 Songs
            </a>
            <a href="${pageContext.request.contextPath}/admin/dashboard?tab=users"
               class="nav-link <%= "users".equals(request.getAttribute("activeTab")) ? "active" : "" %>">
               👤 Users
            </a>
        </nav>
        <a href="#" class="logout-btn" onclick="document.getElementById('logoutModal').classList.add('show'); return false;">Logout</a>
    </div>

    <!-- Main Content -->
    <div class="admin-main">

        <!-- Header -->
        <div class="admin-header">
            <h1>Welcome, <%= admin.getName() %></h1>
            <p class="subtitle">Manage your music platform</p>
        </div>

        <!-- Songs Section -->
        <% if ("songs".equals(request.getAttribute("activeTab"))) { %>
        <div class="admin-section" id="songs-section">
            <div class="section-header">
                <h2>All Songs</h2>
                <a href="${pageContext.request.contextPath}/admin/songs?action=add" class="add-btn">+ Add Song</a>
            </div>

            <table class="song-table">
                <tr>
                    <th>#</th>
                    <th>Title</th>
                    <th>Artist</th>
                    <th>Genre</th>
                    <th>Actions</th>
                </tr>
                <% if (songs == null || songs.isEmpty()) { %>
                    <tr><td colspan="5">No songs found.</td></tr>
                <% } else { %>
                    <% for (SongModel song : songs) { %>
                        <tr>
                            <td><%= song.getId() %></td>
                            <td><%= song.getTitle() %></td>
                            <td><%= song.getArtist() %></td>
                            <td><%= song.getGenre() %></td>
                            <td class="action-btns">
                               <a href="${pageContext.request.contextPath}/admin/songs?action=edit&id=<%= song.getId() %>" class="edit-btn">Edit</a>
                               <a href="#" class="delete-btn"onclick="openDeleteModal('<%= song.getId() %>'); return false;">Delete</a>
                            </td>
                        </tr>
                    <% } %>
                <% } %>
            </table>
        </div>
        <% } %>

        <!-- Users Section -->
        <% if ("users".equals(request.getAttribute("activeTab"))) { %>
        <div class="admin-section" id="users-section">
            <div class="section-header">
                <h2>All Users</h2>
            </div>

            <table class="song-table">
                <tr>
                    <th>#</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                </tr>
                <% if (users == null || users.isEmpty()) { %>
                    <tr><td colspan="4">No users found.</td></tr>
                <% } else { %>
                    <% for (UserModel u : users) { %>
                        <tr>
                            <td><%= u.getId() %></td>
                            <td><%= u.getName() %></td>
                            <td><%= u.getEmail() %></td>
                            <td><%= u.getRole() %></td>
                        </tr>
                    <% } %>
                <% } %>
            </table>
        </div>
        <% } %>
    </div>
</div>

<!-- Login Success Popup -->
<% if ("true".equals(loginSuccessAdmin)) { %>
<div class="modal-overlay show" id="loginModal">
    <div class="modal-box">
        <div class="modal-icon">✅</div>
        <h3>Logged In Successfully!</h3>
        <p>Welcome back, <strong><%= admin.getName() %></strong>!</p>
        <button class="modal-ok-btn" onclick="document.getElementById('loginModal').classList.remove('show')">OK</button>
    </div>
</div>
<% } %>

<!-- Song Added Popup -->
<% if ("added".equals(songSuccess)) { %>
<div class="modal-overlay show" id="songModal">
    <div class="modal-box">
        <div class="modal-icon">🎵</div>
        <h3>Song Added!</h3>
        <p>The song was added successfully.</p>
        <button class="modal-ok-btn" onclick="document.getElementById('songModal').classList.remove('show')">OK</button>
    </div>
</div>
<% } %>

<!-- Song Edited Popup -->
<% if ("edited".equals(songSuccess)) { %>
<div class="modal-overlay show" id="songModal">
    <div class="modal-box">
        <div class="modal-icon">✏️</div>
        <h3>Song Updated!</h3>
        <p>The song was updated successfully.</p>
        <button class="modal-ok-btn" onclick="document.getElementById('songModal').classList.remove('show')">OK</button>
    </div>
</div>
<% } %>

<!-- Song Deleted Popup -->
<% if ("deleted".equals(songSuccess)) { %>
<div class="modal-overlay show" id="songModal">
    <div class="modal-box">
        <div class="modal-icon">🗑️</div>
        <h3>Song Deleted!</h3>
        <p>The song was removed successfully.</p>
        <button class="modal-ok-btn" onclick="document.getElementById('songModal').classList.remove('show')">OK</button>
    </div>
</div>
<% } %>

<!-- Logout Confirm Modal — always in DOM so the logout button always works -->
<div class="logout-modal-overlay" id="logoutModal">
    <div class="logout-modal-box">
        <div class="modal-icon">🚪</div>
        <h3>Logout</h3>
        <p>Are you sure you want to logout?</p>
        <div class="logout-modal-actions">
            <button class="logout-cancel-btn" onclick="document.getElementById('logoutModal').classList.remove('show')">Cancel</button>
            <a href="${pageContext.request.contextPath}/logout"><button class="logout-confirm-btn">Yes, Logout</button></a>
        </div>
    </div>
</div>

<div class="logout-modal-overlay" id="deleteModal">
    <div class="logout-modal-box">
        <div class="modal-icon">🗑️</div>
        <h3>Delete Song</h3>
        <p>Are you sure you want to delete this song?</p>
        <div class="logout-modal-actions">
            <button class="logout-cancel-btn"
                onclick="document.getElementById('deleteModal').classList.remove('show')">
                Cancel
            </button>

            <a id="confirmDeleteLink">
                <button class="logout-confirm-btn">Yes, Delete</button>
            </a>
        </div>
    </div>
</div>

<script>
function openDeleteModal(id) {
    document.getElementById("deleteModal").classList.add("show");

    document.getElementById("confirmDeleteLink").href =
        "${pageContext.request.contextPath}/admin/songs?action=delete&id=" + id;
}
</script>
</body>
</html>
