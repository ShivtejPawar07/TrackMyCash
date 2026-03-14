<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track My Cash - Login</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;700;900&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-deep: #050801;
            --neon-teal: #03e9f4;
            --text-white: #ffffff;
            --glass-bg: rgba(255, 255, 255, 0.05);
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Montserrat', sans-serif;
            background: radial-gradient(#050801, #000000);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .auth-container {
            position: relative;
            width: 100%;
            max-width: 900px;
            min-height: 500px;
            background: var(--glass-bg);
            backdrop-filter: blur(15px);
            border: 2px solid var(--neon-teal);
            box-shadow: 0 0 50px rgba(3, 233, 244, 0.3);
            border-radius: 10px;
            display: flex;
            overflow: hidden;
            margin: 20px;
        }

        /* Ambient Glow effect on border */
        .auth-container::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            border: 1px solid var(--neon-teal);
            box-shadow: inset 0 0 15px rgba(3, 233, 244, 0.5);
            pointer-events: none;
            z-index: 10;
        }

        .auth-form-side {
            flex: 1.2;
            padding: 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            z-index: 5;
        }

        .auth-welcome-side {
            flex: 0.8;
            background: linear-gradient(135deg, rgba(3, 233, 244, 0.1), transparent);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
            border-left: 1px solid rgba(3, 233, 244, 0.2);
            z-index: 5;
        }

        .welcome-text {
            color: var(--neon-teal);
            font-size: 3.5rem;
            font-weight: 900;
            line-height: 1.1;
            text-transform: uppercase;
            letter-spacing: 5px;
            opacity: 0.8;
            user-select: none;
            text-shadow: 0 0 10px rgba(3, 233, 244, 0.5);
        }

        .login-box h2 {
            margin: 0 0 40px;
            padding: 0;
            color: var(--text-white);
            font-size: 2.2rem;
            font-weight: 700;
        }

        .user-box {
            position: relative;
            margin-bottom: 30px;
        }

        .user-box input {
            width: 100%;
            padding: 10px 0;
            font-size: 16px;
            color: #fff;
            margin-bottom: 30px;
            border: none;
            border-bottom: 1px solid #fff;
            outline: none;
            background: transparent;
            transition: 0.5s;
        }

        .user-box label {
            position: absolute;
            top: 0;
            left: 0;
            padding: 10px 0;
            font-size: 16px;
            color: #fff;
            pointer-events: none;
            transition: 0.5s;
        }

        .user-box input:focus ~ label,
        .user-box input:valid ~ label {
            top: -20px;
            left: 0;
            color: var(--neon-teal);
            font-size: 12px;
        }

        .user-box input:focus {
            border-bottom: 1px solid var(--neon-teal);
            box-shadow: 0 1px 0 0 var(--neon-teal);
        }

        .user-box i {
            position: absolute;
            right: 0;
            top: 10px;
            color: rgba(255, 255, 255, 0.5);
            font-size: 1.1rem;
        }

        /* Neon Button */
        .neon-btn {
            position: relative;
            display: inline-block;
            padding: 15px 30px;
            color: var(--neon-teal);
            font-size: 16px;
            text-decoration: none;
            text-transform: uppercase;
            overflow: hidden;
            transition: 0.5s;
            margin-top: 20px;
            letter-spacing: 4px;
            background: transparent;
            border: 1px solid var(--neon-teal);
            cursor: pointer;
            width: 100%;
            font-weight: 700;
            border-radius: 5px;
        }

        .neon-btn:hover {
            background: var(--neon-teal);
            color: #fff;
            border-radius: 5px;
            box-shadow: 0 0 5px var(--neon-teal),
                        0 0 25px var(--neon-teal),
                        0 0 50px var(--neon-teal),
                        0 0 100px var(--neon-teal);
        }

        .signup-link {
            margin-top: 30px;
            text-align: center;
            color: #fff;
            font-size: 0.9rem;
            opacity: 0.7;
        }

        .signup-link a {
            color: var(--neon-teal);
            text-decoration: none;
            font-weight: 700;
        }

        .signup-link a:hover {
            text-decoration: underline;
        }

        .alert-error {
            background: rgba(255, 0, 0, 0.1);
            border: 1px solid #ff0000;
            color: #ff0000;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 0.85rem;
            text-align: center;
        }

        @media (max-width: 768px) {
            .auth-welcome-side {
                display: none;
            }
            .auth-container {
                max-width: 450px;
            }
            .auth-form-side {
                padding: 40px;
            }
        }
    </style>
</head>
<body>

    <div class="auth-container">
        <!-- Main Form Side -->
        <div class="auth-form-side">
            <div class="login-box">
                <h2>Login</h2>

                <% if(request.getParameter("msg")!=null){ %>
                    <div class="alert-error">
                        <i class="fa-solid fa-triangle-exclamation me-2"></i>
                        <%= request.getParameter("msg") %>
                    </div>
                <% } %>

                <form action="LoginServlet" method="post">
                    <div class="user-box">
                        <input type="text" name="email" required="">
                        <label>Username</label>
                        <i class="fa-solid fa-user"></i>
                    </div>
                    <div class="user-box">
                        <input type="password" name="password" required="">
                        <label>Password</label>
                        <i class="fa-solid fa-lock"></i>
                    </div>
                    
                    <button type="submit" class="neon-btn">
                        Login
                    </button>
                </form>

                <div class="signup-link">
                    Don't have an account? <br>
                    <a href="signup.jsp">Sign Up</a>
                </div>
            </div>
        </div>

        <!-- Welcome Text Side -->
        <div class="auth-welcome-side">
            <div class="welcome-text">
                Welcome<br>Back!
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
