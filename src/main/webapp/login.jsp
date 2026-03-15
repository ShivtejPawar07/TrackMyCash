<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track My Cash - Login Terminal</title>
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
            --accent-purple: #8b5cf6;
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --glass-bg: rgba(15, 23, 42, 0.75);
            --glass-border: rgba(255, 255, 255, 0.1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Rajdhani', sans-serif;
            background: radial-gradient(circle at center, #0f172a, #020617);
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            perspective: 1500px;
            position: relative;
        }

        /* Animated Background Elements */
        .bg-glow {
            position: absolute;
            width: 600px;
            height: 600px;
            border-radius: 50%;
            z-index: -1;
            filter: blur(120px);
            opacity: 0.4;
            animation: pulse-glow 15s infinite alternate ease-in-out;
        }

        @keyframes pulse-glow {
            0% { transform: translate(-20%, -20%) scale(1); opacity: 0.3; }
            100% { transform: translate(20%, 20%) scale(1.3); opacity: 0.6; }
        }

        @keyframes float {
            0% { transform: translateY(0px) rotateX(0deg) rotateY(0deg); }
            50% { transform: translateY(-20px) rotateX(1deg) rotateY(-1deg); }
            100% { transform: translateY(0px) rotateX(0deg) rotateY(0deg); }
        }

        .auth-wrapper {
            width: 100%;
            max-width: 1050px;
            padding: 20px;
            animation: float 6s infinite ease-in-out;
            transform-style: preserve-3d;
        }

        .auth-container {
            position: relative;
            width: 100%;
            min-height: 600px;
            display: flex;
            background: var(--glass-bg);
            backdrop-filter: blur(35px);
            border-radius: 40px;
            border: 1px solid var(--glass-border);
            box-shadow: 0 50px 120px -20px rgba(0, 0, 0, 0.85);
            overflow: hidden;
            transition: transform 0.15s ease-out;
            transform-style: preserve-3d;
        }

        /* Neon Border Animation */
        .neon-border {
            position: absolute;
            inset: -4px;
            background: conic-gradient(from 0deg, 
                transparent, var(--accent-cyan), 
                transparent, var(--accent-purple), 
                transparent, var(--accent-cyan));
            border-radius: 42px;
            z-index: -1;
            animation: rotate-gradient 3s linear infinite;
            opacity: 0.9;
        }

        @keyframes rotate-gradient {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Panes: Strict 50/50 Split */
        .auth-form-side {
            flex: 1;
            padding: 80px 70px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: rgba(15, 23, 42, 0.45);
            transform: translateZ(40px);
        }

        .auth-welcome-side {
            flex: 1;
            padding: 80px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, rgba(6, 182, 212, 0.25), rgba(139, 92, 246, 0.25));
            border-left: 1px solid var(--glass-border);
            position: relative;
            overflow: hidden;
            transform: translateZ(60px);
        }

        .welcome-content {
            text-align: center;
            z-index: 2;
        }

        .welcome-title {
            font-family: 'Orbitron', sans-serif;
            font-size: 4.5rem;
            font-weight: 950;
            background: linear-gradient(to bottom, #fff, var(--accent-cyan));
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 35px;
            line-height: 0.9;
            text-transform: uppercase;
            letter-spacing: 12px;
            filter: drop-shadow(0 0 20px rgba(6, 182, 212, 0.6));
        }

        .welcome-subtitle {
            font-size: 1.3rem;
            color: #fff;
            max-width: 300px;
            margin: 0 auto;
            letter-spacing: 4px;
            font-weight: 600;
            text-transform: uppercase;
            opacity: 0.9;
            border-top: 1px solid rgba(255,255,255,0.2);
            padding-top: 20px;
        }

        .login-box h2 {
            font-family: 'Orbitron', sans-serif;
            margin-bottom: 50px;
            font-size: 3.2rem;
            font-weight: 900;
            letter-spacing: 5px;
            color: #fff;
            position: relative;
        }

        .login-box h2::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: -15px;
            width: 60px;
            height: 4px;
            background: var(--accent-cyan);
            box-shadow: 0 0 15px var(--accent-cyan);
        }

        /* Underline Style Fields */
        .input-group-custom {
            position: relative;
            margin-bottom: 50px;
        }

        .input-group-custom input {
            width: 100%;
            padding: 15px 0 15px 45px;
            background: transparent;
            border: none;
            border-bottom: 2px solid var(--glass-border);
            color: var(--text-primary);
            font-size: 1.25rem;
            outline: none;
            transition: all 0.4s;
            border-radius: 0;
        }

        .input-group-custom .underline-bar {
            position: absolute;
            bottom: 0px;
            left: 50%;
            width: 0;
            height: 2px;
            background: var(--accent-cyan);
            transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 0 15px var(--accent-cyan);
        }

        .input-group-custom input:focus ~ .underline-bar {
            width: 100%;
            left: 0;
        }

        .input-group-custom i {
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            color: var(--accent-cyan);
            font-size: 1.5rem;
            transition: all 0.3s ease;
            opacity: 0.8;
        }

        .input-group-custom label {
            position: absolute;
            left: 45px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            font-size: 1.15rem;
            pointer-events: none;
            transition: all 0.3s ease;
        }

        .input-group-custom input:focus ~ label,
        .input-group-custom input:valid ~ label {
            top: -20px;
            left: 0;
            font-size: 0.95rem;
            color: var(--accent-cyan);
            font-weight: 800;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        /* Glowing Login Button */
        .btn-neon {
            width: 100%;
            padding: 22px;
            margin-top: 25px;
            background: var(--accent-cyan);
            border: none;
            color: #020617;
            font-family: 'Orbitron', sans-serif;
            font-size: 1.4rem;
            font-weight: 950;
            text-transform: uppercase;
            border-radius: 60px;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            letter-spacing: 5px;
            box-shadow: 0 15px 35px rgba(6, 182, 212, 0.4);
            position: relative;
            z-index: 1;
        }

        .btn-neon:hover {
            transform: translateY(-6px) scale(1.04);
            background: #fff;
            box-shadow: 0 25px 50px rgba(255, 255, 255, 0.5), 0 0 80px var(--accent-cyan);
        }

        .signup-link {
            margin-top: 60px;
            text-align: center;
            color: var(--text-secondary);
            font-size: 1.15rem;
            letter-spacing: 1.5px;
        }

        .signup-link a {
            color: var(--accent-cyan);
            text-decoration: none;
            font-weight: 800;
            margin-left: 8px;
            transition: all 0.4s;
            position: relative;
        }

        .signup-link a::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 0;
            height: 2px;
            background: var(--accent-cyan);
            transition: width 0.3s;
        }

        .signup-link a:hover::after { width: 100%; }
        .signup-link a:hover { color: #fff; text-shadow: 0 0 15px var(--accent-cyan); }

        .alert-custom {
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid #ef4444;
            color: #ef4444;
            padding: 20px;
            border-radius: 18px;
            margin-bottom: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            animation: shake 0.5s ease-in-out;
            font-weight: 600;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-6px); }
            40%, 80% { transform: translateX(6px); }
        }

        @media (max-width: 991px) {
            body { perspective: none; overflow-y: auto; }
            .auth-wrapper { animation: none; padding: 25px; }
            .auth-container { flex-direction: column; min-height: auto; }
            .auth-welcome-side { display: none; }
            .auth-form-side { padding: 70px 50px; transform: none; }
            .neon-border { inset: -2px; border-radius: 27px; }
            .auth-container { border-radius: 25px; }
        }

        .particle {
            position: absolute;
            background: #fff;
            border-radius: 50%;
            pointer-events: none;
            z-index: -1;
            box-shadow: 0 0 12px var(--accent-cyan);
        }
    </style>
</head>
<body>

    <div class="bg-glow" style="top: -100px; right: -100px; background: radial-gradient(circle, var(--accent-cyan) 0%, transparent 70%);"></div>
    <div class="bg-glow" style="bottom: -100px; left: -100px; background: radial-gradient(circle, var(--accent-purple) 0%, transparent 70%); animation-delay: -7s;"></div>

    <div class="auth-wrapper">
        <div class="auth-container" id="tilt-card">
            <div class="neon-border"></div>
            
            <!-- Side A: Control Console -->
            <div class="auth-form-side">
                <div class="login-box">
                    <h2>LOGIN</h2>

                    <% if(request.getParameter("msg")!=null){ %>
                        <div class="alert-custom">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                            <%= request.getParameter("msg") %>
                        </div>
                    <% } %>

                    <form action="LoginServlet" method="post" autocomplete="off">
                        <div class="input-group-custom">
                            <i class="fa-solid fa-envelope"></i>
                            <input type="text" name="email" id="email" required>
                            <label for="email">User Email</label>
                            <div class="underline-bar"></div>
                        </div>
                        
                        <div class="input-group-custom">
                            <i class="fa-solid fa-lock"></i>
                            <input type="password" name="password" id="password" required>
                            <label for="password">Password</label>
                            <div class="underline-bar"></div>
                        </div>
                        
                        <button type="submit" class="btn-neon">
                            Initialize Login
                        </button>
                    </form>

                    <div class="signup-link">
                        Don't have an account? 
                        <a href="signup.jsp">Register Interface</a>
                    </div>
                </div>
            </div>

            <!-- Side B: Visual Protocol -->
            <div class="auth-welcome-side">
                <div class="welcome-content">
                    <div class="welcome-title">
                        WELCOME<br>BACK
                    </div>
                    <div class="welcome-subtitle">
                        Finance Protocol Online.
                    </div>
                </div>
                
                <div style="position: absolute; top: 15%; right: 10%; width: 180px; height: 180px; border: 1px solid var(--accent-cyan); border-radius: 50%; opacity: 0.15; border-style: dashed; animation: rotate-gradient 20s linear infinite;"></div>
                <div style="position: absolute; bottom: 15%; left: 10%; width: 220px; height: 220px; border: 1px solid var(--accent-purple); border-radius: 50%; opacity: 0.15; border-style: dotted; animation: rotate-gradient 30s linear infinite reverse;"></div>
            </div>
        </div>
    </div>

    <script>
        const card = document.getElementById('tilt-card');
        const wrapper = document.querySelector('.auth-wrapper');

        if (window.innerWidth > 991) {
            document.addEventListener('mousemove', (e) => {
                let xAxis = (window.innerWidth / 2 - e.pageX) / 45;
                let yAxis = (window.innerHeight / 2 - e.pageY) / 45;
                card.style.transform = `rotateY(${xAxis}deg) rotateX(${-yAxis}deg)`;
            });

            document.addEventListener('mouseleave', () => {
                card.style.transform = `rotateY(0deg) rotateX(0deg)`;
            });
            
            wrapper.addEventListener('mouseenter', () => {
                wrapper.style.animationPlayState = 'paused';
            });
            wrapper.addEventListener('mouseleave', () => {
                wrapper.style.animationPlayState = 'running';
            });
        }

        function createParticles() {
            for (let i = 0; i < 30; i++) {
                let p = document.createElement('div');
                p.className = 'particle';
                let size = Math.random() * 4 + 1;
                p.style.width = size + 'px';
                p.style.height = size + 'px';
                p.style.left = Math.random() * 100 + 'vw';
                p.style.top = Math.random() * 100 + 'vh';
                p.style.opacity = Math.random() * 0.5;
                document.body.appendChild(p);
                animateParticle(p);
            }
        }

        function animateParticle(p) {
            let duration = Math.random() * 10000 + 7000;
            p.animate([
                { transform: 'translate(0, 0)' },
                { transform: `translate(${Math.random() * 300 - 150}px, ${Math.random() * 300 - 150}px)` }
            ], {
                duration: duration,
                iterations: Infinity,
                direction: 'alternate',
                easing: 'ease-in-out'
            });
        }

        createParticles();
    </script>
</body>
</html>
