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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-bg: #0a0f1c;
            --card-bg: rgba(22, 30, 48, 0.7);
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --accent-color: #00f2ff;
            --accent-glow: rgba(0, 242, 255, 0.5);
            --gradient-start: #00f2ff;
            --gradient-end: #0066ff;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--primary-bg);
            background-image: 
                radial-gradient(circle at 10% 20%, rgba(0, 102, 255, 0.15) 0%, transparent 40%),
                radial-gradient(circle at 90% 80%, rgba(0, 242, 255, 0.1) 0%, transparent 40%);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            position: relative;
            overflow: hidden;
        }

        /* Ambient floating shapes */
        .shape {
            position: absolute;
            background: linear-gradient(45deg, var(--gradient-start), var(--gradient-end));
            filter: blur(80px);
            opacity: 0.3;
            z-index: -1;
            border-radius: 50%;
            animation: float 10s infinite ease-in-out alternate;
        }
        .shape-1 { top: -100px; left: -100px; width: 400px; height: 400px; }
        .shape-2 { bottom: -150px; right: -50px; width: 500px; height: 500px; animation-delay: -5s; }

        @keyframes float {
            0% { transform: translateY(0) scale(1); }
            100% { transform: translateY(-30px) scale(1.1); }
        }

        .auth-wrapper {
            width: 100%;
            max-width: 1000px;
            padding: 2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10;
        }

        /* Glassmorphism Card */
        .auth-card {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 24px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5), 0 0 20px rgba(0, 242, 255, 0.1);
            overflow: hidden;
            display: flex;
            flex-direction: row;
            width: 100%;
            transform: translateY(0);
            transition: all 0.4s ease;
        }

        .auth-card:hover {
            box-shadow: 0 30px 60px -15px rgba(0, 0, 0, 0.6), 0 0 30px rgba(0, 242, 255, 0.15);
            transform: translateY(-5px);
        }

        /* Form Side */
        .auth-form-side {
            padding: 3.5rem;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        /* Image/Branding Side */
        .auth-image-side {
            flex: 1;
            background: linear-gradient(135deg, rgba(0, 102, 255, 0.8), rgba(0, 242, 255, 0.8)), url('https://images.unsplash.com/photo-1551288049-bebda4e38f71?q=80&w=1470&auto=format&fit=crop') center/cover;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 3rem;
            text-align: center;
            position: relative;
        }
        
        .auth-image-side::before {
            content: '';
            position: absolute;
            inset: 0;
            background: rgba(10, 15, 28, 0.3);
        }

        .auth-image-content {
            position: relative;
            z-index: 1;
        }

        .brand-logo {
            font-size: 3rem;
            font-weight: 700;
            background: linear-gradient(90deg, #fff, #e0e7ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 1rem;
        }

        .brand-tagline {
            font-size: 1.1rem;
            color: rgba(255, 255, 255, 0.9);
            font-weight: 300;
        }

        .auth-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: #fff;
        }

        .auth-subtitle {
            color: var(--text-muted);
            margin-bottom: 2.5rem;
            font-size: 0.95rem;
        }

        /* Custom Input Styling */
        .form-floating > .form-control {
            background-color: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: #fff;
            border-radius: 12px;
            padding-left: 3rem;
            height: 3.5rem;
            transition: all 0.3s ease;
        }

        .form-floating > .form-control:focus {
            background-color: rgba(255, 255, 255, 0.06);
            border-color: var(--accent-color);
            box-shadow: 0 0 0 4px rgba(0, 242, 255, 0.1);
        }

        .form-floating > label {
            color: var(--text-muted);
            padding-left: 3rem;
        }

        .form-floating > .form-control:focus ~ label,
        .form-floating > .form-control:not(:placeholder-shown) ~ label {
            color: var(--accent-color);
            transform: scale(0.85) translateY(-0.75rem) translateX(0.5rem);
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            z-index: 4;
            transition: color 0.3s ease;
        }

        .form-floating > .form-control:focus ~ .input-icon {
            color: var(--accent-color);
        }

        /* Stylish Button */
        .btn-auth {
            background: linear-gradient(90deg, var(--gradient-start), var(--gradient-end));
            color: #fff;
            border: none;
            border-radius: 12px;
            padding: 0.8rem 1.5rem;
            font-size: 1.1rem;
            font-weight: 600;
            width: 100%;
            height: 3.5rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            z-index: 1;
        }

        .btn-auth::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(90deg, var(--gradient-end), var(--gradient-start));
            opacity: 0;
            z-index: -1;
            transition: opacity 0.3s ease;
        }

        .btn-auth:hover {
            color: #fff;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px -10px var(--accent-glow);
        }

        .btn-auth:hover::before {
            opacity: 1;
        }

        .auth-footer {
            margin-top: 2rem;
            text-align: center;
            color: var(--text-muted);
        }

        .auth-link {
            color: var(--accent-color);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .auth-link:hover {
            color: #fff;
            text-decoration: underline;
        }

        .alert-error {
            background: rgba(255, 77, 109, 0.1);
            border-left: 4px solid #ff4d6d;
            color: #ffb3c1;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Mobile Responsiveness */
        @media (max-width: 991px) {
            .auth-card {
                flex-direction: column-reverse;
                max-width: 500px;
            }
            .auth-image-side {
                padding: 2rem;
                min-height: 200px;
            }
            .auth-form-side {
                padding: 2.5rem 2rem;
            }
        }
    </style>
</head>
<body>

    <div class="shape shape-1"></div>
    <div class="shape shape-2"></div>

    <div class="auth-wrapper">
        <div class="auth-card">
            
            <div class="auth-form-side">
                <div>
                    <h2 class="auth-title">Welcome Back</h2>
                    <p class="auth-subtitle">Sign in to track your cash flow</p>

                    <% if(request.getParameter("msg")!=null){ %>
                        <div class="alert-error">
                            <i class="fa-solid fa-circle-exclamation"></i>
                            <span><%= request.getParameter("msg") %></span>
                        </div>
                    <% } %>

                    <form action="LoginServlet" method="post">
                        <!-- Changed back to standard form-control relative design to support icon correctly inside form-floating -->
                        <!-- Actually, form-floating puts the label on top of everything if not careful. The input-icon needs to be aligned. -->
                        <div class="position-relative mb-4">
                            <i class="fa-solid fa-envelope input-icon"></i>
                            <div class="form-floating">
                                <input type="email" class="form-control" id="email" name="email" placeholder="name@example.com" required>
                                <label for="email">Email Address</label>
                            </div>
                        </div>

                        <div class="position-relative mb-4">
                            <i class="fa-solid fa-lock input-icon"></i>
                            <div class="form-floating">
                                <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                                <label for="password">Password</label>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-auth mt-2">
                            Sign In <i class="fa-solid fa-arrow-right ms-2"></i>
                        </button>
                    </form>

                    <div class="auth-footer">
                        <p class="mb-0">Don't have an account? <a href="signup.jsp" class="auth-link">Create one</a></p>
                    </div>
                </div>
            </div>

            <div class="auth-image-side">
                <div class="auth-image-content">
                    <div class="brand-logo">
                        <i class="fa-solid fa-wallet text-white mb-2"></i><br>
                        TrackMyCash
                    </div>
                    <p class="brand-tagline">Master your finances with our beautifully designed tracking dashboard.</p>
                </div>
            </div>

        </div>
    </div>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
