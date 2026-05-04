<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%
    String  error          = (String)  request.getAttribute("error");
    String  rememberedEmail= (String)  request.getAttribute("rememberedEmail");
    String  registered     = request.getParameter("registered");
    String  passwordReset  = request.getParameter("passwordReset");
    Boolean locked         = (Boolean) request.getAttribute("locked");

    Long lockSecondsRemaining = (Long) request.getAttribute("lockSecondsRemaining");
    if (lockSecondsRemaining == null) lockSecondsRemaining = 0L;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Login – MyMusicList</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">

<div class="container">
    <div class="logo">🎵</div>
    <h2>MyMusicList</h2>
    <p class="subtitle">Sign in to your account</p>

    <% if (error != null) { %>
    <div class="alert <%= Boolean.TRUE.equals(locked) ? "warn-alert" : "" %>">
        <%= error %>
        <% if (Boolean.TRUE.equals(locked) && lockSecondsRemaining > 0) { %>
        <div class="countdown-wrap">
            Unlocks in: <strong id="countdown"><%= lockSecondsRemaining %>s</strong>
        </div>
        <% } %>
    </div>
    <% } %>

    <% if ("true".equals(registered)) { %>
    <div class="alert success">Account created! You can now log in.</div>
    <% } %>
    <% if ("true".equals(passwordReset)) { %>
    <div class="alert success">Password reset successfully! Please log in.</div>
    <% } %>

    <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
        <div class="input-group">
            <span class="input-icon">✉</span>
            <%-- autocomplete="email" keeps the browser email suggestions when typing --%>
            <input type="email" name="email"
                   value="<%= rememberedEmail != null ? rememberedEmail : "" %>"
                   placeholder="Email address" required id="emailInput"
                   autocomplete="email">
        </div>
        <div class="input-group">
            <span class="input-icon">🔒</span>
            <%-- autocomplete="new-password" stops browsers auto-filling the password on page load --%>
            <input type="password" name="password" placeholder="Password" required id="passwordInput"
                   autocomplete="new-password">
        </div>
        <div class="remember-row">
            <label class="remember-label">
                <input type="checkbox" name="rememberMe"> Remember me
            </label>
            <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-link">Forgot password?</a>
        </div>

        <% if (Boolean.TRUE.equals(locked)) { %>
        <button type="submit" id="submitBtn" disabled class="btn-locked">
            🔒 Locked – wait <span id="btnCountdown"><%= lockSecondsRemaining %>s</span>
        </button>
        <% } else { %>
        <button type="submit" id="submitBtn">Sign In</button>
        <% } %>
    </form>

    <div class="divider">or</div>
    <a href="${pageContext.request.contextPath}/register">
        Don't have an account? <strong>Register here</strong>
    </a>
</div>

<% if (Boolean.TRUE.equals(locked) && lockSecondsRemaining > 0) { %>
<script>
    var seconds = <%= lockSecondsRemaining %>;
    var countdownEl  = document.getElementById('countdown');
    var btnCountdown = document.getElementById('btnCountdown');
    var submitBtn    = document.getElementById('submitBtn');

    var timer = setInterval(function() {
        seconds--;
        if (seconds <= 0) {
            clearInterval(timer);
            submitBtn.disabled = false;
            submitBtn.classList.remove('btn-locked');
            submitBtn.textContent = 'Sign In';
            if (countdownEl) countdownEl.parentElement.style.display = 'none';
        } else {
            if (countdownEl)  countdownEl.textContent  = seconds + 's';
            if (btnCountdown) btnCountdown.textContent = seconds + 's';
        }
    }, 1000);
</script>
<% } %>

</body>
</html>
