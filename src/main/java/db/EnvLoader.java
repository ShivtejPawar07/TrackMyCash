package db;

import java.io.*;
import java.util.Properties;

/**
 * Utility class to load environment variables from a .env file.
 * Searches for the .env file in the application's classpath parent directories
 * and common project root locations.
 */
public class EnvLoader {

    private static Properties props = null;

    /**
     * Loads the .env file and returns the value for the given key.
     * Caches the properties after first load for performance.
     */
    public static String get(String key) {
        if (props == null) {
            props = new Properties();
            loadEnvFile();
        }
        // Fallback to system environment variable if not found in .env
        String value = props.getProperty(key);
        if (value == null) {
            value = System.getenv(key);
        }
        return value;
    }

    private static void loadEnvFile() {
        // Try multiple possible locations for the .env file
        String[] possiblePaths = {
            // Tomcat's working directory (catalina.base)
            System.getProperty("catalina.base") + File.separator + "webapps"
                + File.separator + "TrackMyCash" + File.separator + ".env",
            // Project root (for development in Eclipse)
            System.getProperty("user.dir") + File.separator + ".env",
            // Relative to where the class might be loaded
            ".env"
        };

        for (String path : possiblePaths) {
            File envFile = new File(path);
            if (envFile.exists() && envFile.isFile()) {
                try (BufferedReader reader = new BufferedReader(new FileReader(envFile))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        line = line.trim();
                        // Skip empty lines and comments
                        if (line.isEmpty() || line.startsWith("#")) continue;
                        int idx = line.indexOf('=');
                        if (idx > 0) {
                            String k = line.substring(0, idx).trim();
                            String v = line.substring(idx + 1).trim();
                            props.setProperty(k, v);
                        }
                    }
                    System.out.println("[EnvLoader] Loaded .env from: " + envFile.getAbsolutePath());
                    return; // Found and loaded, stop searching
                } catch (IOException e) {
                    System.err.println("[EnvLoader] Error reading .env at " + path + ": " + e.getMessage());
                }
            }
        }
        System.err.println("[EnvLoader] WARNING: .env file not found in any expected location!");
    }
}
