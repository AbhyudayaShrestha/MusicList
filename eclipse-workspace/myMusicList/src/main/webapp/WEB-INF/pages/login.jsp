<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>MyMusicList – Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="container">
    <div class="logo">🎵</div>
    <h2>Welcome User</h2>
    <p class="subtitle">Login to your MyMusicList account</p>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
        <div class="alert"><%= error %></div>
    <% } %>

    <form action="login" method="post">
        <div class="input-group">
            <span class="input-icon">✉</span>
            <input type="email" name="email" placeholder="Email address" required>
        </div>
        <div class="input-group">
            <span class="input-icon">🔒</span>
            <input type="password" name="password" placeholder="Password" required>
        </div>
        <button type="submit">Login</button>
    </form>

    <div class="divider"><span>or</span></div>
    <a href="register">Don't have an account yet? <strong>Sign Up</strong></a>
</div>

</body>
</html>
