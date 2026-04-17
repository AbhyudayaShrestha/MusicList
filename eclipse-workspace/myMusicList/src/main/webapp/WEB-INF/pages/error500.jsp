<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Server Error – MyMusicList</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
    <div class="logo">🎵</div>
    <h2>500 – Something Went Wrong</h2>
    <p class="subtitle">We hit a snag on our end. Please try again shortly.</p>
    <br>
    <a href="${pageContext.request.contextPath}/dashboard"><strong>← Go back to Dashboard</strong></a>
</div>
</body>
</html>