<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<%@ page import="db.EnvLoader" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String driver = EnvLoader.get("DB_DRIVER");
    String url = EnvLoader.get("DB_URL");
    String user = EnvLoader.get("DB_USER");
    String password = EnvLoader.get("DB_PASSWORD");
    
    Connection con = null;
    String error = null;
    long start = System.currentTimeMillis();
    try {
        con = DBConnection.getConnection();
    } catch (Exception e) {
        error = e.getMessage();
    }
    long end = System.currentTimeMillis();
%>

<!DOCTYPE html>
<html>
<head>
    <title>DB Diagnostic Tool</title>
    <style>
        body { font-family: sans-serif; background: #0f172a; color: #f8fafc; padding: 2rem; }
        .card { background: #1e293b; border: 1px solid #334155; border-radius: 12px; padding: 2rem; max-width: 800px; margin: auto; }
        .status { font-weight: bold; padding: 0.5rem 1rem; border-radius: 6px; display: inline-block; margin-bottom: 1rem; }
        .success { background: #065f46; color: #34d399; }
        .fail { background: #7f1d1d; color: #f87171; }
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th, td { text-align: left; padding: 0.75rem; border-bottom: 1px solid #334155; }
        th { color: #94a3b8; width: 30%; }
        code { background: #0f172a; padding: 0.2rem 0.4rem; border-radius: 4px; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Database Connection Diagnostic</h1>
        
        <% if (con != null) { %>
            <div class="status success">✓ CONNECTION SUCCESSFUL</div>
        <% } else { %>
            <div class="status fail">✗ CONNECTION FAILED</div>
        <% } %>

        <table>
            <tr><th>Variable</th><th>Status / Value</th></tr>
            <tr>
                <td>DB_DRIVER</td>
                <td><%= driver != null ? "<code>" + driver + "</code>" : "<span style='color:#f87171'>MISSING</span>" %></td>
            </tr>
            <tr>
                <td>DB_URL</td>
                <td><%= url != null ? "<code>" + (url.length() > 20 ? url.substring(0, 20) + "..." : url) + "</code>" : "<span style='color:#f87171'>MISSING</span>" %></td>
            </tr>
            <tr>
                <td>DB_USER</td>
                <td><%= user != null ? "<code>" + user + "</code>" : "<span style='color:#f87171'>MISSING</span>" %></td>
            </tr>
            <tr>
                <td>DB_PASSWORD</td>
                <td><%= password != null ? "<code>********</code>" : "<span style='color:#f87171'>MISSING</span>" %></td>
            </tr>
            <tr>
                <td>Response Time</td>
                <td><%= (end - start) %> ms</td>
            </tr>
            <% if (error != null || System.getProperty("last_db_error") != null) { %>
            <tr>
                <td>Error Message</td>
                <td style="color:#f87171"><code><%= error != null ? error : System.getProperty("last_db_error") %></code></td>
            </tr>
            <% } %>
        </table>

        <div style="margin-top: 2rem;">
            <a href="login.jsp" style="color:#3b82f6; text-decoration: none;">&larr; Back to Login</a>
        </div>
    </div>
</body>
</html>
