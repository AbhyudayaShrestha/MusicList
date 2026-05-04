<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Integer step  = (Integer) request.getAttribute("step");
    String  email = (String)  request.getAttribute("email");
    String  question = (String) request.getAttribute("question");
    String  error = (String)  request.getAttribute("error");
    if (step == null) step = 1;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password – MyMusicList</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">

<div class="container">
    <div class="logo">🔑</div>

    <% if (step == 1) { %>
    <!-- ── Step 1: Enter Email ──────────────────────────────────── -->
    <h2>Forgot Password</h2>
    <p class="subtitle">Enter your email to find your account</p>

    <% if (error != null) { %><div class="alert"><%= error %></div><% } %>

    <form action="${pageContext.request.contextPath}/forgot-password" method="post">
        <input type="hidden" name="step" value="1">
        <div class="input-group">
            <span class="input-icon">✉</span>
            <input type="email" name="email" placeholder="Your email address" required autofocus>
        </div>
        <button type="submit">Find My Account</button>
    </form>

    <div class="divider"></div>
    <a href="${pageContext.request.contextPath}/login">← Back to Login</a>

    <% } else if (step == 2) { %>
    <!-- ── Step 2: Answer Security Question ─────────────────────── -->
    <h2>Security Question</h2>
    <p class="subtitle">Answer your security question to continue</p>

    <% if (error != null) { %><div class="alert"><%= error %></div><% } %>

    <div class="security-question-box">
        <p class="sq-label">Your question:</p>
        <p class="sq-text"><%= question %></p>
    </div>

    <form action="${pageContext.request.contextPath}/forgot-password" method="post">
        <input type="hidden" name="step"  value="2">
        <input type="hidden" name="email" value="<%= email %>">
        <div class="input-group">
            <span class="input-icon">💬</span>
            <input type="text" name="answer" placeholder="Your answer" required autofocus>
        </div>
        <button type="submit">Verify Answer</button>
    </form>

    <div class="divider"></div>
    <a href="${pageContext.request.contextPath}/forgot-password">← Start Over</a>

    <% } else if (step == 3) { %>
    <!-- ── Step 3: Set New Password ─────────────────────────────── -->
    <h2>Set New Password</h2>
    <p class="subtitle">Choose a strong new password</p>

    <% if (error != null) { %><div class="alert"><%= error %></div><% } %>

    <form action="${pageContext.request.contextPath}/forgot-password" method="post">
        <input type="hidden" name="step"  value="3">
        <input type="hidden" name="email" value="<%= email %>">
        <div class="input-group">
            <span class="input-icon">🔒</span>
            <input type="password" name="newPassword" placeholder="New password (min 8 chars)"
                   minlength="8" required autofocus>
        </div>
        <div class="input-group">
            <span class="input-icon">🔒</span>
            <input type="password" name="confirmPassword" placeholder="Confirm new password"
                   minlength="8" required>
        </div>
        <button type="submit">Reset Password</button>
    </form>

    <% } %>
</div>

</body>
</html>
