<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myMusicList.model.UserModel" %>
<%
    UserModel user = (UserModel) session.getAttribute("loggedUser");
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
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
        </div>

        <h2>Your Songs</h2>
        <p class="subtitle">Your personal music collection</p>

        <table class="song-table">
            <tr>
                <th>#</th>
                <th>Title</th>
                <th>Artist</th>
                <th>Genre</th>
            </tr>
            <tr>
                <td colspan="4">No songs yet — coming soon!</td>
            </tr>
        </table>

    </div>
</body>
</html>