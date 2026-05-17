<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register – MyMusicList</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body class="auth-split-page">

<div class="auth-split-wrapper">

    <!-- left panel -->
    <div class="auth-panel-left auth-panel-left--register">
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
                <h1>Start your<br>music journey.</h1>
                <p>Discover, collect and share<br>the music that defines you.</p>
            </div>

            <ul class="auth-feature-list">
                <li class="auth-feature-item">
                    <span class="auth-feature-icon-wrap">
                        <svg viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M3 10a7 7 0 1014 0A7 7 0 003 10z" stroke="rgba(255,255,255,0.7)" stroke-width="1.4"/>
                            <path d="M8 10l2 2 4-4" stroke="rgba(255,255,255,0.7)" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </span>
                    <span>Track everything you listen to</span>
                </li>
                <li class="auth-feature-item">
                    <span class="auth-feature-icon-wrap">
                        <svg viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <rect x="3" y="4" width="14" height="12" rx="2" stroke="rgba(255,255,255,0.7)" stroke-width="1.4"/>
                            <path d="M7 8h6M7 11h4" stroke="rgba(255,255,255,0.7)" stroke-width="1.4" stroke-linecap="round"/>
                        </svg>
                    </span>
                    <span>Build and manage your playlists</span>
                </li>
                <li class="auth-feature-item">
                    <span class="auth-feature-icon-wrap">
                        <svg viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <rect x="3" y="8" width="5" height="9" rx="1" stroke="rgba(255,255,255,0.7)" stroke-width="1.4"/>
                            <rect x="7.5" y="5" width="5" height="12" rx="1" stroke="rgba(255,255,255,0.7)" stroke-width="1.4"/>
                            <rect x="12" y="3" width="5" height="14" rx="1" stroke="rgba(255,255,255,0.7)" stroke-width="1.4"/>
                        </svg>
                    </span>
                    <span>Secure and private by default</span>
                </li>
            </ul>

            <div class="auth-note-bubbles" aria-hidden="true">
                <span class="note-bubble nb1">&#9835;</span>
                <span class="note-bubble nb2">&#9833;</span>
                <span class="note-bubble nb3">&#9834;</span>
                <span class="note-bubble nb4">&#9836;</span>
                <span class="note-bubble nb5">&#9835;</span>
            </div>

        </div>
    </div>

    <!-- right panel -->
    <div class="auth-panel-right">
        <div class="auth-form-box auth-form-box--wide">

            <div class="auth-form-header">
                <h2>Create your account</h2>
                <p class="auth-form-sub">Join MyMusicList – it only takes a minute</p>
            </div>

            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
            <div class="alert"><%= error %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/register" method="post">

                <div class="form-row-two">
                    <div class="form-col">
                        <div class="form-field-label">Full name</div>
                        <div class="input-group">
                            <span class="input-icon input-icon-svg">
                                <svg viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <circle cx="10" cy="7" r="3.5" stroke="#aaa" stroke-width="1.4"/>
                                    <path d="M3 17c0-3.314 3.134-6 7-6s7 2.686 7 6" stroke="#aaa" stroke-width="1.4" stroke-linecap="round"/>
                                </svg>
                            </span>
                            <input type="text" name="name" placeholder="Jane Smith" required>
                        </div>
                    </div>
                    <div class="form-col">
                        <div class="form-field-label">Email address</div>
                        <div class="input-group">
                            <span class="input-icon input-icon-svg">
                                <svg viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M2.5 5.5A1.5 1.5 0 014 4h12a1.5 1.5 0 011.5 1.5v9A1.5 1.5 0 0116 16H4a1.5 1.5 0 01-1.5-1.5v-9z" stroke="#aaa" stroke-width="1.4"/>
                                    <path d="M2.5 6l7.5 5 7.5-5" stroke="#aaa" stroke-width="1.4" stroke-linecap="round"/>
                                </svg>
                            </span>
                            <input type="email" name="email" placeholder="you@example.com" required>
                        </div>
                    </div>
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
                    <input type="password" name="password" placeholder="Min 8 characters" minlength="8" required>
                </div>

                <div class="form-row-two">
                    <div class="form-col">
                        <div class="form-field-label">Security question</div>
                        <div class="input-group select-group">
                            <span class="input-icon input-icon-svg">
                                <svg viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <circle cx="10" cy="10" r="7.5" stroke="#aaa" stroke-width="1.4"/>
                                    <path d="M10 11.5V12m0-5a1.5 1.5 0 011.5 1.5c0 .828-.672 1.25-1.5 1.5" stroke="#aaa" stroke-width="1.4" stroke-linecap="round"/>
                                </svg>
                            </span>
                            <select name="securityQuestion" required class="select-input">
                                <option value="" disabled selected>Choose a question…</option>
                                <option value="What was the name of your first pet?">First pet's name?</option>
                                <option value="What is your mother's maiden name?">Mother's maiden name?</option>
                                <option value="What city were you born in?">City of birth?</option>
                                <option value="What was the name of your primary school?">Primary school name?</option>
                                <option value="What is your favourite movie?">Favourite movie?</option>
                                <option value="What street did you grow up on?">Street you grew up on?</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-col">
                        <div class="form-field-label">Your answer</div>
                        <div class="input-group">
                            <span class="input-icon input-icon-svg">
                                <svg viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M3 5.5A1.5 1.5 0 014.5 4h11A1.5 1.5 0 0117 5.5v7A1.5 1.5 0 0115.5 14H11l-4 3v-3H4.5A1.5 1.5 0 013 12.5v-7z" stroke="#aaa" stroke-width="1.4" stroke-linejoin="round"/>
                                </svg>
                            </span>
                            <input type="text" name="securityAnswer"
                                   placeholder="Used to recover password" required>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn-primary-full">Create Account</button>
            </form>

            <div class="auth-divider"><span>or</span></div>

            <a href="${pageContext.request.contextPath}/login" class="btn-secondary-full">
                Already have an account? Sign in
            </a>

        </div>
    </div>

</div>

</body>
</html>
