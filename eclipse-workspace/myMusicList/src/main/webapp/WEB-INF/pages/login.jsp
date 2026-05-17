<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%
    String  error              = (String)  request.getAttribute("error");
    String  rememberedEmail    = (String)  request.getAttribute("rememberedEmail");
    String  registered         = request.getParameter("registered");
    String  passwordReset      = request.getParameter("passwordReset");
    Boolean locked             = (Boolean) request.getAttribute("locked");
    Long lockSecondsRemaining  = (Long) request.getAttribute("lockSecondsRemaining");
    if (lockSecondsRemaining == null) lockSecondsRemaining = 0L;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – MyMusicList</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body class="auth-split-page">

<div class="auth-split-wrapper">

    <!-- left panel -->
    <div class="auth-panel-left">
        <div class="auth-panel-overlay"></div>
        <div class="auth-panel-content">

            <div class="auth-brand">
                <svg class="auth-brand-svg" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M9 18V5l12-2v13" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    <circle cx="6" cy="18" r="3" stroke="white" stroke-width="2"/>
                    <circle cx="18" cy="16" r="3" stroke="white" stroke-width="2"/>
                </svg>
                <span class="auth-brand-name">MyMusicList</span>
            </div>

            <div class="auth-panel-headline">
                <h1>Your music,<br>your story.</h1>
                <p>Track every song. Build every playlist.</p>
            </div>

            <div class="auth-art">
                <svg viewBox="0 0 260 260" xmlns="http://www.w3.org/2000/svg" class="auth-vinyl-svg" aria-hidden="true">
                    <circle cx="130" cy="130" r="120" fill="rgba(255,255,255,0.05)" stroke="rgba(255,255,255,0.13)" stroke-width="1.5"/>
                    <circle cx="130" cy="130" r="100" fill="rgba(255,255,255,0.04)" stroke="rgba(255,255,255,0.09)" stroke-width="1"/>
                    <circle cx="130" cy="130" r="80"  fill="rgba(255,255,255,0.04)" stroke="rgba(255,255,255,0.07)" stroke-width="1"/>
                    <circle cx="130" cy="130" r="60"  fill="rgba(255,255,255,0.04)" stroke="rgba(255,255,255,0.06)" stroke-width="1"/>
                    <circle cx="130" cy="130" r="40"  fill="rgba(255,255,255,0.04)" stroke="rgba(255,255,255,0.05)" stroke-width="1"/>
                    <circle cx="130" cy="130" r="28"  fill="rgba(102,126,234,0.6)"/>
                    <circle cx="130" cy="130" r="6"   fill="rgba(255,255,255,0.45)"/>
                    <ellipse cx="104" cy="82" rx="24" ry="12" fill="rgba(255,255,255,0.06)" transform="rotate(-30 104 82)"/>
                </svg>

                <div class="auth-waveform" aria-hidden="true">
                    <span class="wv-bar"></span>
                    <span class="wv-bar"></span>
                    <span class="wv-bar"></span>
                    <span class="wv-bar"></span>
                    <span class="wv-bar"></span>
                    <span class="wv-bar"></span>
                    <span class="wv-bar"></span>
                    <span class="wv-bar"></span>
                    <span class="wv-bar"></span>
                    <span class="wv-bar"></span>
                </div>
            </div>

        </div>
    </div>

    <!-- right panel -->
    <div class="auth-panel-right">
        <div class="auth-form-box">

            <div class="auth-form-header">
                <h2>Welcome back</h2>
                <p class="auth-form-sub">Sign in to continue to MyMusicList</p>
            </div>

            <% if (error != null) { %>
            <div class="alert <%= Boolean.TRUE.equals(locked) ? "warn-alert" : "" %>">
                <%= error %>
                <% if (Boolean.TRUE.equals(locked) && lockSecondsRemaining > 0) { %>
                <div class="countdown-wrap">Unlocks in: <strong id="countdown"><%= lockSecondsRemaining %>s</strong></div>
                <% } %>
            </div>
            <% } %>
            <% if ("true".equals(registered)) { %><div class="alert success">Account created! You can now log in.</div><% } %>
            <% if ("true".equals(passwordReset)) { %><div class="alert success">Password reset successfully! Please log in.</div><% } %>

            <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">

                <div class="form-field-label">Email address</div>
                <div class="input-group">
                    <span class="input-icon input-icon-svg">
                        <svg viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M2.5 5.5A1.5 1.5 0 014 4h12a1.5 1.5 0 011.5 1.5v9A1.5 1.5 0 0116 16H4a1.5 1.5 0 01-1.5-1.5v-9z" stroke="#aaa" stroke-width="1.4"/>
                            <path d="M2.5 6l7.5 5 7.5-5" stroke="#aaa" stroke-width="1.4" stroke-linecap="round"/>
                        </svg>
                    </span>
                    <input type="email" name="email"
                           value="<%= rememberedEmail != null ? rememberedEmail : "" %>"
                           placeholder="you@example.com" required id="emailInput"
                           autocomplete="email">
                </div>

                <div class="form-field-label">Password</div>
                <div class="input-group">
                    <span class="input-icon input-icon-svg">
                        <svg viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <rect x="4" y="9" width="12" height="8" rx="1.5" stroke="#aaa" stroke-width="1.4"/>
                            <path d="M7 9V6.5a3 3 0 016 0V9" stroke="#aaa" stroke-width="1.4" stroke-linecap="round"/>
                            <circle cx="10" cy="13" r="1.2" fill="#aaa"/>
                        </svg>
                    </span>
                    <input type="password" name="password" placeholder="Enter your password"
                           required id="passwordInput" autocomplete="current-password">
                </div>

                <div class="remember-row">
                    <label class="remember-label">
                        <input type="checkbox" name="rememberMe"> Remember me
                    </label>
                    <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-link">Forgot password?</a>
                </div>

                <% if (Boolean.TRUE.equals(locked)) { %>
                <button type="submit" id="submitBtn" disabled class="btn-primary-full btn-locked-state">
                    Locked – wait <span id="btnCountdown"><%= lockSecondsRemaining %>s</span>
                </button>
                <% } else { %>
                <button type="submit" id="submitBtn" class="btn-primary-full">Sign In</button>
                <% } %>
            </form>

            <div class="auth-divider"><span>or</span></div>

            <a href="${pageContext.request.contextPath}/register" class="btn-secondary-full">
                Create a new account
            </a>

        </div>
    </div>

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
            submitBtn.classList.remove('btn-locked-state');
            submitBtn.textContent = 'Sign In';
            if (countdownEl) countdownEl.parentElement.style.display = 'none';
        } else {
            if (countdownEl)  countdownEl.textContent  = seconds + 's';
            if (btnCountdown) btnCountdown.textContent = seconds + 's';
        }
    }, 1000);
</script>
<% } %>


<script>
    
    window.addEventListener('pageshow', function(event) {
        if (event.persisted) {
            window.location.reload();
        }
    });
</script>
</body>
</html>
