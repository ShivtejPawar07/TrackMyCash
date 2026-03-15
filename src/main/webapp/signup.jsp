<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track My Cash - Create Account</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Rajdhani:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-dark: #020617;
            --accent-cyan: #06b6d4;
            --accent-blue: #3b82f6;
            --accent-purple: #8b5cf6;
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --glass-bg: rgba(15, 23, 42, 0.6);
            --glass-border: rgba(255, 255, 255, 0.1);
            --neon-shadow: 0 0 20px rgba(6, 182, 212, 0.5);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Rajdhani', sans-serif;
            background: radial-gradient(circle at top right, #0f172a, #020617);
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow-x: hidden;
            position: relative;
        }

        /* Animated Background Elements */
        .bg-glow {
            position: absolute;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(6, 182, 212, 0.15) 0%, transparent 70%);
            border-radius: 50%;
            z-index: -1;
            filter: blur(50px);
            animation: pulse-glow 10s infinite alternate;
        }

        @keyframes pulse-glow {
            0% { transform: translate(-10%, -10%) scale(1); opacity: 0.5; }
            100% { transform: translate(10%, 10%) scale(1.2); opacity: 0.8; }
        }

        .auth-container {
            position: relative;
            width: 100%;
            max-width: 1000px;
            min-height: 650px;
            display: flex;
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            border: 1px solid var(--glass-border);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            overflow: hidden;
            margin: 20px;
            transition: transform 0.3s ease;
        }

        .auth-container::before {
            content: '';
            position: absolute;
            inset: -2px;
            background: linear-gradient(45deg, var(--accent-cyan), transparent, var(--accent-purple), transparent, var(--accent-cyan));
            background-size: 400% 400%;
            z-index: -1;
            animation: border-glow 15s linear infinite;
            border-radius: 26px;
        }

        @keyframes border-glow {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .auth-form-side {
            flex: 1.2;
            padding: 50px 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: rgba(15, 23, 42, 0.3);
        }

        .auth-welcome-side {
            flex: 0.8;
            padding: 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, rgba(6, 182, 212, 0.1), rgba(139, 92, 246, 0.1));
            border-left: 1px solid var(--glass-border);
            position: relative;
            overflow: hidden;
        }

        .welcome-content {
            text-align: center;
            z-index: 2;
        }

        .welcome-title {
            font-family: 'Orbitron', sans-serif;
            font-size: 3.5rem;
            font-weight: 900;
            background: linear-gradient(45deg, var(--accent-cyan), var(--accent-purple));
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 20px;
            line-height: 1.1;
            text-transform: uppercase;
            letter-spacing: 4px;
        }

        .welcome-subtitle {
            font-size: 1.25rem;
            color: var(--text-secondary);
            max-width: 250px;
            margin: 0 auto;
            letter-spacing: 1px;
        }

        .login-box h2 {
            font-family: 'Orbitron', sans-serif;
            margin-bottom: 35px;
            font-size: 2.2rem;
            font-weight: 700;
            letter-spacing: 2px;
            color: var(--text-primary);
        }

        .input-group-custom {
            position: relative;
            margin-bottom: 30px;
        }

        .input-group-custom label {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            font-size: 1.1rem;
            transition: all 0.3s ease;
            pointer-events: none;
            background: transparent;
            padding: 0 5px;
        }

        .input-group-custom input {
            width: 100%;
            padding: 15px 15px 15px 45px;
            background: rgba(15, 23, 42, 0.5);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            color: var(--text-primary);
            font-size: 1.1rem;
            outline: none;
            transition: all 0.3s ease;
        }

        .input-group-custom i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--accent-cyan);
            font-size: 1.2rem;
            transition: all 0.3s ease;
        }

        .input-group-custom input:focus,
        .input-group-custom input:valid {
            border-color: var(--accent-cyan);
            box-shadow: 0 0 15px rgba(6, 182, 212, 0.2);
        }

        .input-group-custom input:focus ~ label,
        .input-group-custom input:valid ~ label {
            top: -12px;
            left: 10px;
            font-size: 0.9rem;
            color: var(--accent-cyan);
            background: #020617;
            padding: 0 10px;
            border-radius: 4px;
        }

        .btn-neon {
            width: 100%;
            padding: 15px;
            margin-top: 10px;
            background: transparent;
            border: 2px solid var(--accent-cyan);
            color: var(--accent-cyan);
            font-family: 'Orbitron', sans-serif;
            font-size: 1.2rem;
            font-weight: 700;
            text-transform: uppercase;
            border-radius: 12px;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            transition: all 0.5s ease;
            letter-spacing: 2px;
        }

        .btn-neon:hover {
            background: var(--accent-cyan);
            color: #fff;
            box-shadow: 0 0 10px var(--accent-cyan), 0 0 40px var(--accent-cyan);
            transform: translateY(-2px);
        }

        .signup-link {
            margin-top: 30px;
            text-align: center;
            color: var(--text-secondary);
            font-size: 1.1rem;
        }

        .signup-link a {
            color: var(--accent-cyan);
            text-decoration: none;
            font-weight: 700;
            transition: all 0.3s ease;
        }

        .signup-link a:hover {
            text-shadow: 0 0 8px var(--accent-cyan);
            text-decoration: underline;
        }

        .alert-custom {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid #ef4444;
            color: #ef4444;
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-size: 1rem;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        @media (max-width: 991px) {
            .auth-container {
                max-width: 500px;
                flex-direction: column;
            }
            .auth-welcome-side {
                display: none;
            }
            .auth-form-side {
                padding: 40px 30px;
            }
        }
    </style>
</head>
<body>

    <div class="bg-glow" style="top: 10%; right: 10%;"></div>
    <div class="bg-glow" style="bottom: 10%; left: 10%; animation-delay: -5s;"></div>

    <div class="auth-container">
        <!-- Main Form Side -->
        <div class="auth-form-side">
            <div class="login-box">
                <h2>CREATE ID</h2>

                <%
                    String msg = request.getParameter("msg");
                    if(msg != null){
                %>
                    <div class="alert-custom">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <%= msg %>
                    </div>
                <% } %>

                <form action="SignupServlet" method="post" autocomplete="off">
                    <div class="input-group-custom">
                        <i class="fa-solid fa-user-astronaut"></i>
                        <input type="text" name="name" id="name" required>
                        <label for="name">Full Identity Name</label>
                    </div>
                    
                    <div class="input-group-custom">
                        <i class="fa-solid fa-envelope-open-text"></i>
                        <input type="email" name="email" id="email" required>
                        <label for="email">Digital Email Address</label>
                    </div>
                    
                    <div class="input-group-custom">
                        <i class="fa-solid fa-key"></i>
                        <input type="password" name="password" id="password" required>
                        <label for="password">Security Credentials</label>
                    </div>
                    
                    <button type="submit" class="btn-neon">
                        INITIALIZE ACCOUNT
                    </button>
                </form>

                <div class="signup-link">
                    Already registered? 
                    <a href="login.jsp">Access Portal</a>
                </div>
            </div>
        </div>

        <!-- Welcome Text Side -->
        <div class="auth-welcome-side">
            <div class="welcome-content">
                <div class="welcome-title">
                    JOIN<br>US
                </div>
                <div class="welcome-subtitle">
                    Create your unique identity and start your financial journey.
                </div>
            </div>
            
            <div style="position: absolute; top: -50px; right: -50px; width: 200px; height: 200px; background: var(--accent-cyan); opacity: 0.1; filter: blur(80px); border-radius: 50%;"></div>
            <div style="position: absolute; bottom: -50px; left: -50px; width: 250px; height: 250px; background: var(--accent-purple); opacity: 0.1; filter: blur(80px); border-radius: 50%;"></div>
        </div>
    </div>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
