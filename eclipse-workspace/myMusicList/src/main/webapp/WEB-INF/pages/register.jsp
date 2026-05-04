<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register – MyMusicList</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">

<div class="container">
    <div class="logo">🎵</div>
    <h2>Create Account</h2>
    <p class="subtitle">Join MyMusicList today</p>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %><div class="alert"><%= error %></div><% } %>

    <form action="${pageContext.request.contextPath}/register" method="post">

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
            <input type="password" name="password" placeholder="Password (min 8 chars)"
                   minlength="8" required>
        </div>

        <!-- Security Question (used for forgot password) -->
        <div class="input-group select-group">
            <span class="input-icon">🛡</span>
            <select name="securityQuestion" required class="select-input">
                <option value="" disabled selected>Select a security question…</option>
                <option value="What was the name of your first pet?">What was the name of your first pet?</option>
                <option value="What is your mother's maiden name?">What is your mother's maiden name?</option>
                <option value="What city were you born in?">What city were you born in?</option>
                <option value="What was the name of your primary school?">What was the name of your primary school?</option>
                <option value="What is your favourite movie?">What is your favourite movie?</option>
                <option value="What street did you grow up on?">What street did you grow up on?</option>
            </select>
        </div>

        <div class="input-group">
            <span class="input-icon">💬</span>
            <input type="text" name="securityAnswer" placeholder="Your answer (used to recover password)" required>
        </div>

        <button type="submit">Create Account</button>
    </form>

    <div class="divider">or</div>
    <a href="${pageContext.request.contextPath}/login">Already have an account? <strong>Login</strong></a>
</div>

</body>
</html>
