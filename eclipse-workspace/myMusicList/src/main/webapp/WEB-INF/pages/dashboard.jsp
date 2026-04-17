<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myMusicList.model.UserModel" %>
<%@ page import="com.myMusicList.model.SongModel" %>
<%@ page import="java.util.List" %>
<%
    UserModel user = (UserModel) session.getAttribute("loggedUser");
    List<SongModel> songs = (List<SongModel>) request.getAttribute("songs");
    String loginSuccess = request.getParameter("loginSuccess");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard – MyMusicList</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container dashboard-container">

        <div class="top-bar">
            <div>
                <div class="logo">🎵 MyMusicList</div>
                <p class="subtitle">Welcome back, <strong><%= user.getName() %></strong>!</p>
            </div>
            <a href="#" class="logout-btn" onclick="document.getElementById('logoutModal').classList.add('show'); return false;">Logout</a>
        </div>

        <h2>Music Library</h2>
        <p class="subtitle">Songs you can choose from</p>

        <!-- Maintenance Notice -->
        <div class="alert info">
            ⚠️ <strong>Maintenance Notice:</strong> Add-to-playlist feature is currently under development. 
            You will be able to add songs after the next milestone.
        </div>

        <% if (songs == null || songs.isEmpty()) { %>
            <div class="alert info">
                🎶 No songs in the list yet. Ask an admin to add some!
            </div>
        <% } else { %>
        <table class="song-table">
            <tr>
                <th>#</th>
                <th>Title</th>
                <th>Artist</th>
                <th>Genre</th>
            </tr>
            <%
                int count = 1;
                for (SongModel song : songs) {
            %>
            <tr>
                <td><%= count++ %></td>
                <td><%= song.getTitle() %></td>
                <td><%= song.getArtist() %></td>
                <td><%= song.getGenre() %></td>
            </tr>
            <% } %>
        </table>
        <% } %>
    </div>

    <!-- Login Success Popup -->
    <% if ("true".equals(loginSuccess)) { %>
    <div class="modal-overlay show" id="loginModal">
        <div class="modal-box">
            <div class="modal-icon">✅</div>
            <h3>Logged In Successfully!</h3>
            <p>Welcome back, <strong><%= user.getName() %></strong>!</p>
            <button class="modal-ok-btn" onclick="document.getElementById('loginModal').classList.remove('show')">OK</button>
        </div>
    </div>
    <% } %>

    <!-- Logout Confirm Modal -->
    <div class="logout-modal-overlay" id="logoutModal">
        <div class="logout-modal-box">
            <div class="modal-icon">🚪</div>
            <h3>Logout</h3>
            <p>Are you sure you want to logout?</p>
            <div class="logout-modal-actions">
                <button class="logout-cancel-btn" onclick="document.getElementById('logoutModal').classList.remove('show')">Cancel</button>
                <a href="${pageContext.request.contextPath}/logout">
                    <button class="logout-confirm-btn">Yes, Logout</button>
                </a>
            </div>
        </div>
    </div>

</body>
</html>