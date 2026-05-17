<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Server Error – MyMusicList</title>
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
    <div class="logo">😵</div>
    <h2>500 – Something Went Wrong</h2>
    <p class="subtitle">Something broke on our end — please try again in a bit.</p>
    <br>
    <a href="${pageContext.request.contextPath}/dashboard"><strong>← Go back to Dashboard</strong></a>
</div>
</body>
</html>
