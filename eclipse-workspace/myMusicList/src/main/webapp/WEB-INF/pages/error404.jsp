<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Page Not Found – MyMusicList</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        html, body {
            height: 100%;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="logo">🎶</div>
    <h2>404 – Page Not Found</h2>
    <p class="subtitle">Hmm, this page doesn't exist.</p>
    <br>
    <a href="${pageContext.request.contextPath}/dashboard"><strong>← Go back to Dashboard</strong></a>
</div>
</body>
</html>
