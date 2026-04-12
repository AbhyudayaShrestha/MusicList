<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>MyMusicList – Register</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="container">
    <div class="logo">🎵</div>
    <h2>Create Account</h2>
    <p class="subtitle">Join MyMusicList today</p>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
        <div class="alert"><%= error %></div>
    <% } %>

    <form action="register" method="post">
        <div class="input-group">
            <span class="input-icon">👤</span>
            <input type="text" name="name" placeholder="Full name" required>
        </div>
        <div class="input-group">
            <span class="input-icon">✉</span>
            <input type="email" name="email" placeholder="Email address" required>
        </div>
        <div class="input-group">
            <span class="input-icon">🔒</span>
            <input type="password" name="password" placeholder="Password" required>
        </div>
        <button type="submit">Create Account</button>
    </form>

    <div class="divider"><span>or</span></div>
    <a href="login">Already have an account? <strong>Login</strong></a>
</div>

</body>
</html>
