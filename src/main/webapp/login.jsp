<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Login</title>

<style>
*{
    box-sizing:border-box;
    font-family:'Segoe UI',sans-serif;
}

body{
    margin:0;
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:#050b14;
}

/* CARD */
.container{
    width:760px;
    height:420px;
    display:flex;
    border-radius:18px;
    overflow:hidden;
    background:rgba(255,255,255,0.06);
    backdrop-filter:blur(14px);
    box-shadow:0 0 40px rgba(0,234,255,0.35);
}

/* LEFT */
.left{
    flex:1;
    padding:45px;
    color:#e8fdff;
}

.left h2{
    margin-bottom:35px;
    letter-spacing:1px;
    color:#bffaff;
}

.input-box{
    position:relative;
    margin-bottom:24px;
}

.input-box input{
    width:100%;
    padding:12px 40px 12px 12px;
    border:none;
    background:transparent;
    border-bottom:1px solid rgba(191,250,255,0.5);
    color:#fff;
}

.input-box input:focus{
    outline:none;
    border-bottom:1px solid #00eaff;
}

.input-box span{
    position:absolute;
    right:10px;
    top:50%;
    transform:translateY(-50%);
    color:#bffaff;
}

/* BUTTON */
button{
    width:100%;
    padding:12px;
    border:none;
    border-radius:25px;
    font-size:15px;
    cursor:pointer;
    color:#002a33;
    background:linear-gradient(135deg,#00eaff,#0099ff);
    box-shadow:0 0 18px rgba(0,234,255,0.6);
}

button:hover{
    box-shadow:0 0 26px rgba(0,234,255,0.9);
}

/* LINKS */
.left a{
    color:#00eaff;
    text-decoration:none;
}

/* RIGHT PANEL */
.right{
    flex:1;
    background:linear-gradient(135deg,#00eaff,#0099ff);
    clip-path:polygon(18% 0,100% 0,100% 100%,0 100%);
    display:flex;
    justify-content:center;
    align-items:center;
}

.right h1{
    color:white;
    letter-spacing:2px;
    text-align:center;
}

/* ERROR */
.error{
    color:#ff6b6b;
    text-align:center;
    margin-bottom:15px;
}

</style>
</head>

<body>

<div class="container">

    <div class="left">
        <h2>Login</h2>

        <% if(request.getParameter("msg")!=null){ %>
            <div class="error"><%= request.getParameter("msg") %></div>
        <% } %>

        <form action="LoginServlet" method="post">
            <div class="input-box">
                <input type="email" name="email" placeholder="Username" required>
                <span>👤</span>
            </div>

            <div class="input-box">
                <input type="password" name="password" placeholder="Password" required>
                <span>🔒</span>
            </div>

            <button type="submit">Login</button>
        </form>

        <p>Don't have an account?
            <a href="signup.jsp">Sign Up</a>
        </p>
    </div>

    <div class="right">
        <h1>WELCOME<br>BACK!</h1>
    </div>

</div>

</body>
</html>
