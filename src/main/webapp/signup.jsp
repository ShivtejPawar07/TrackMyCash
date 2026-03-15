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
            --glass-bg: rgba(15, 23, 42, 0.7);
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
            width: 500px;
            height: 500px;
            border-radius: 50%;
            z-index: -1;
            filter: blur(80px);
            opacity: 0.4;
            animation: pulse-glow 15s infinite alternate ease-in-out;
        }

        @keyframes pulse-glow {
            0% { transform: translate(-20%, -20%) scale(1); opacity: 0.3; }
            100% { transform: translate(20%, 20%) scale(1.3); opacity: 0.6; }
        }

        /* Float Animation */
        @keyframes float {
            0% { transform: translateY(0px) rotateX(0deg) rotateY(0deg); }
            50% { transform: translateY(-15px) rotateX(1deg) rotateY(-1deg); }
            100% { transform: translateY(0px) rotateX(0deg) rotateY(0deg); }
        }

        .auth-wrapper {
            width: 100%;
            max-width: 1000px;
            padding: 20px;
            animation: float 6s infinite ease-in-out;
            transform-style: preserve-3d;
        }

        .auth-container {
            position: relative;
            width: 100%;
            min-height: 650px;
            display: flex;
            background: var(--glass-bg);
            backdrop-filter: blur(25px);
            border-radius: 30px;
            border: 1px solid var(--glass-border);
            box-shadow: 0 50px 100px -20px rgba(0, 0, 0, 0.7);
            overflow: hidden;
            transition: transform 0.15s ease-out;
            transform-style: preserve-3d;
        }

        /* Neon Border Animation Layer */
        .neon-border {
            position: absolute;
            inset: -4px;
            background: conic-gradient(from 0deg, 
                transparent, 
                var(--accent-cyan), 
                transparent, 
                var(--accent-purple), 
                transparent, 
                var(--accent-cyan));
            border-radius: 32px;
            z-index: -1;
            animation: rotate-gradient 4s linear infinite;
            opacity: 0.8;
        }

        @keyframes rotate-gradient {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .auth-form-side {
            flex: 1.2;
            padding: 50px 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: rgba(15, 23, 42, 0.4);
            transform: translateZ(30px);
        }

        .auth-welcome-side {
            flex: 0.8;
            padding: 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, rgba(6, 182, 212, 0.15), rgba(139, 92, 246, 0.15));
            border-left: 1px solid var(--glass-border);
            position: relative;
            overflow: hidden;
            transform: translateZ(50px);
        }

        .welcome-content {
            text-align: center;
            z-index: 2;
        }

        .welcome-title {
            font-family: 'Orbitron', sans-serif;
            font-size: 3.8rem;
            font-weight: 900;
            background: linear-gradient(45deg, var(--accent-cyan), var(--accent-purple));
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 25px;
            line-height: 1;
            text-transform: uppercase;
            letter-spacing: 6px;
            filter: drop-shadow(0 0 10px rgba(6, 182, 212, 0.3));
        }

        .welcome-subtitle {
            font-size: 1.1rem;
            color: var(--text-secondary);
            max-width: 250px;
            margin: 0 auto;
            letter-spacing: 2px;
            font-weight: 500;
        }

        .login-box h2 {
            font-family: 'Orbitron', sans-serif;
            margin-bottom: 35px;
            font-size: 2.2rem;
            font-weight: 700;
            letter-spacing: 3px;
            color: #fff;
            text-shadow: 0 0 20px rgba(6, 182, 212, 0.4);
        }

        .input-group-custom {
            position: relative;
            margin-bottom: 30px;
        }

        .input-group-custom input {
            width: 100%;
            padding: 16px 16px 16px 50px;
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid var(--glass-border);
            border-radius: 15px;
            color: var(--text-primary);
            font-size: 1.1rem;
            outline: none;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .input-group-custom i {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--accent-cyan);
            font-size: 1.3rem;
            transition: all 0.3s ease;
        }

        .input-group-custom input:focus {
            border-color: var(--accent-cyan);
            box-shadow: 0 0 25px rgba(6, 182, 212, 0.3);
            background: rgba(15, 23, 42, 0.8);
            transform: scale(1.02);
        }

        .input-group-custom label {
            position: absolute;
            left: 50px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            font-size: 1rem;
            pointer-events: none;
            transition: all 0.3s ease;
        }

        .input-group-custom input:focus ~ label,
        .input-group-custom input:valid ~ label {
            top: -12px;
            left: 15px;
            font-size: 0.85rem;
            color: var(--accent-cyan);
            background: var(--bg-dark);
            padding: 0 10px;
            border-radius: 5px;
            font-weight: 600;
            letter-spacing: 1px;
        }

        /* Neon Button */
        .btn-neon {
            width: 100%;
            padding: 18px;
            margin-top: 15px;
            background: var(--accent-cyan);
            border: none;
            color: #020617;
            font-family: 'Orbitron', sans-serif;
            font-size: 1.25rem;
            font-weight: 900;
            text-transform: uppercase;
            border-radius: 15px;
            cursor: pointer;
            transition: all 0.4s;
            letter-spacing: 3px;
            box-shadow: 0 0 15px rgba(6, 182, 212, 0.4);
        }

        .btn-neon:hover {
            background: #fff;
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 0 30px #fff, 0 0 60px var(--accent-cyan);
        }

        .signup-link {
            margin-top: 40px;
            text-align: center;
            color: var(--text-secondary);
            font-size: 1.1rem;
            letter-spacing: 1px;
        }

        .signup-link a {
            color: var(--accent-cyan);
            text-decoration: none;
            font-weight: 700;
            margin-left: 5px;
            position: relative;
        }

        .signup-link a::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 2px;
            background: var(--accent-cyan);
            transition: width 0.3s ease;
        }

        .signup-link a:hover::after {
            width: 100%;
        }

        .alert-custom {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid #ef4444;
            color: #ef4444;
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-size: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            animation: shake 0.5s cubic-bezier(.36,.07,.19,.97) both;
        }

        @keyframes shake {
            10%, 90% { transform: translate3d(-1px, 0, 0); }
            20%, 80% { transform: translate3d(2px, 0, 0); }
            30%, 50%, 70% { transform: translate3d(-4px, 0, 0); }
            40%, 60% { transform: translate3d(4px, 0, 0); }
        }

        @media (max-width: 991px) {
            body { perspective: none; overflow-y: auto; }
            .auth-wrapper { animation: none; padding: 20px 10px; }
            .auth-container { flex-direction: column; min-height: auto; }
            .auth-welcome-side { display: none; }
            .auth-form-side { padding: 50px 30px; transform: none; }
            .neon-border { inset: -2px; border-radius: 17px; }
            .auth-container { border-radius: 15px; }
        }

        /* Abstract Particles */
        .particle {
            position: absolute;
            background: var(--accent-cyan);
            border-radius: 50%;
            pointer-events: none;
            z-index: -1;
            opacity: 0.3;
        }
    </style>
</head>
<body>

    <div class="bg-glow" style="top: -100px; right: -100px; background: radial-gradient(circle, var(--accent-cyan) 0%, transparent 70%);"></div>
    <div class="bg-glow" style="bottom: -100px; left: -100px; background: radial-gradient(circle, var(--accent-purple) 0%, transparent 70%); animation-delay: -7s;"></div>

    <div class="auth-wrapper">
        <div class="auth-container" id="tilt-card">
            <div class="neon-border"></div>
            
            <!-- Main Form Side -->
            <div class="auth-form-side">
                <div class="login-box">
                    <h2>CREATE ID</h2>

                    <%
                        String msg = request.getParameter("msg");
                        if(msg != null){
                    %>
                        <div class="alert-custom">
                            <i class="fa-solid fa-triangle-exclamation"></i>
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
                
                <!-- Circuit-like elements -->
                <div style="position: absolute; top: 10%; width: 80%; height: 1px; background: linear-gradient(90deg, transparent, var(--accent-cyan), transparent); opacity: 0.3;"></div>
                <div style="position: absolute; bottom: 10%; width: 80%; height: 1px; background: linear-gradient(90deg, transparent, var(--accent-purple), transparent); opacity: 0.3;"></div>
            </div>
        </div>
    </div>

    <script>
        const card = document.getElementById('tilt-card');
        const wrapper = document.querySelector('.auth-wrapper');

        // Mouse moving effect for 3D tilt
        if (window.innerWidth > 991) {
            document.addEventListener('mousemove', (e) => {
                let xAxis = (window.innerWidth / 2 - e.pageX) / 45;
                let yAxis = (window.innerHeight / 2 - e.pageY) / 45;
                card.style.transform = `rotateY(${xAxis}deg) rotateX(${-yAxis}deg)`;
            });

            // Smooth return to center
            document.addEventListener('mouseleave', () => {
                card.style.transform = `rotateY(0deg) rotateX(0deg)`;
            });
            
            // Pause float animation on hover for better 3D control
            wrapper.addEventListener('mouseenter', () => {
                wrapper.style.animationPlayState = 'paused';
            });
            wrapper.addEventListener('mouseleave', () => {
                wrapper.style.animationPlayState = 'running';
            });
        }

        // Create background particles
        function createParticles() {
            for (let i = 0; i < 30; i++) {
                let p = document.createElement('div');
                p.className = 'particle';
                let size = Math.random() * 5 + 1;
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
            let duration = Math.random() * 10000 + 5000;
            p.animate([
                { transform: 'translate(0, 0)' },
                { transform: `translate(${Math.random() * 200 - 100}px, ${Math.random() * 200 - 100}px)` }
            ], {
                duration: duration,
                iterations: Infinity,
                direction: 'alternate'
            });
        }

        createParticles();
    </script>
</body>
</html>
