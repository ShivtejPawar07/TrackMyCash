package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.Properties;

/**
 * Database connection manager for Supabase PostgreSQL.
 * Optimized for cloud environments:
 * 1. Thread-safe: Returns a fresh connection per request.
 * 2. Robust URL parsing: Handles postgres:// and postgresql:// formats.
 * 3. SSL Mandatory: Ensures sslmode=require for Supabase.
 */
public class DBConnection {

    private static boolean tablesChecked = false;

    /**
     * Creates and returns a NEW connection to the database.
     * The caller is responsible for closing this connection.
     */
    public static Connection getConnection() {
        try {
            String driver = EnvLoader.get("DB_DRIVER");
            String url = EnvLoader.get("DB_URL");
            String user = EnvLoader.get("DB_USER");
            String password = EnvLoader.get("DB_PASSWORD");

            if (driver == null || url == null || user == null || password == null) {
                System.err.println("[DBConnection] Error: Missing credentials (DRIVER, URL, USER, or PASSWORD)");
                return null;
            }

            // Standardize URL for PostgreSQL JDBC Driver
            if (url.startsWith("postgres://")) {
                url = "jdbc:postgresql://" + url.substring(11);
            } else if (url.startsWith("postgresql://")) {
                url = "jdbc:postgresql://" + url.substring(13);
            } else if (!url.startsWith("jdbc:postgresql://")) {
                url = "jdbc:postgresql://" + url;
            }

            Class.forName(driver);

            Properties props = new Properties();
            props.setProperty("user", user);
            props.setProperty("password", password);
            
            // Supabase and most Cloud DBs require SSL
            if (!url.contains("sslmode=")) {
                props.setProperty("sslmode", "require");
            }

            Connection conn = DriverManager.getConnection(url, props);
            
            // Perform one-time table check
            if (!tablesChecked) {
                checkAndCreateTables(conn);
            }

            return conn;
        } catch (Exception e) {
            String msg = e.getMessage();
            System.err.println("[DBConnection] Connection Failed: " + msg);
            System.setProperty("last_db_error", msg != null ? msg : "Unknown SQL Error");
            return null;
        }
    }

    private synchronized static void checkAndCreateTables(Connection conn) {
        if (tablesChecked) return;
        try (Statement stmt = conn.createStatement()) {
            // Users table
            stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS users (" +
                "  id SERIAL PRIMARY KEY," +
                "  name VARCHAR(100)," +
                "  email VARCHAR(100) UNIQUE," +
                "  password VARCHAR(100)" +
                ")"
            );
            // Customers table
            stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS customers (" +
                "  id SERIAL PRIMARY KEY," +
                "  user_id INTEGER REFERENCES users(id)," +
                "  name VARCHAR(100)," +
                "  phone VARCHAR(15)" +
                ")"
            );
            // Transactions table
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
            tablesChecked = true;
            System.out.println("[DBConnection] Schema verified successfully.");
        } catch (Exception e) {
            System.err.println("[DBConnection] Schema check failed: " + e.getMessage());
        }
    }
}
