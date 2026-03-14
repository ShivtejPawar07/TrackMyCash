package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

/**
 * Database connection manager for Supabase PostgreSQL.
 * 
 * Reads credentials from .env file via EnvLoader.
 * Automatically creates tables on first connection if they don't exist.
 */
public class DBConnection {

    private static Connection con;
    private static boolean tablesCreated = false;

    public static Connection getConnection() {
        try {
            if (con == null || con.isClosed()) {
                String driver = EnvLoader.get("DB_DRIVER");
                String url = EnvLoader.get("DB_URL");
                String user = EnvLoader.get("DB_USER");
                String password = EnvLoader.get("DB_PASSWORD");

                if (driver == null || url == null || user == null || password == null) {
                    System.err.println("[DBConnection] ERROR: Missing database credentials in .env file!");
                    System.err.println("  DB_DRIVER=" + driver);
                    System.err.println("  DB_URL=" + url);
                    System.err.println("  DB_USER=" + user);
                    System.err.println("  DB_PASSWORD=" + (password != null ? "****" : "null"));
                    return null;
                }

                Class.forName(driver);
                con = DriverManager.getConnection(url, user, password);
                System.out.println("[DBConnection] Connected to Supabase PostgreSQL successfully!");

                // Auto-create tables on first connection
                if (!tablesCreated) {
                    createTables(con);
                    tablesCreated = true;
                }
            }
        } catch (Exception e) {
            System.err.println("[DBConnection] Connection failed: " + e.getMessage());
            e.printStackTrace();
        }
        return con;
    }

    /**
     * Automatically creates the required tables if they don't exist.
     * This mirrors the original MySQL schema but uses PostgreSQL syntax.
     */
    private static void createTables(Connection conn) {
        try (Statement stmt = conn.createStatement()) {

            // 1. Users table
            stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS users (" +
                "  id SERIAL PRIMARY KEY," +
                "  name VARCHAR(100)," +
                "  email VARCHAR(100) UNIQUE," +
                "  password VARCHAR(100)" +
                ")"
            );
            System.out.println("[DBConnection] Table 'users' ready.");

            // 2. Customers table
            stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS customers (" +
                "  id SERIAL PRIMARY KEY," +
                "  user_id INTEGER REFERENCES users(id)," +
                "  name VARCHAR(100)," +
                "  phone VARCHAR(15)" +
                ")"
            );
            System.out.println("[DBConnection] Table 'customers' ready.");

            // 3. Transactions table
            stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS transactions (" +
                "  id SERIAL PRIMARY KEY," +
                "  customer_id INTEGER REFERENCES customers(id) ON DELETE CASCADE," +
                "  amount DOUBLE PRECISION," +
                "  type VARCHAR(10)," +
                "  note VARCHAR(255)," +
                "  date TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                ")"
            );
            System.out.println("[DBConnection] Table 'transactions' ready.");

            System.out.println("[DBConnection] All tables created/verified successfully in Supabase!");

        } catch (Exception e) {
            System.err.println("[DBConnection] Error creating tables: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
