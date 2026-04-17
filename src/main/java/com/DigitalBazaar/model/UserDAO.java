package com.DigitalBazaar.model;

import com.DigitalBazaar.config.DBConfig;

import java.sql.*;

import org.mindrot.jbcrypt.BCrypt;

public class UserDAO {

	// REGISTER USER with Encryption
    public boolean registerUser(User user) {
        String query = "INSERT INTO users (username, password, fullname) VALUES (?, ?, ?)";

        // 1. Generate a salt and hash the password
        String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());

        try (Connection conn = DBConfig.getDbConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, hashedPassword); // Save the HASH, not the plain text
            pstmt.setString(3, user.getFullname());

            return pstmt.executeUpdate() > 0;

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error during registration: " + e.getMessage());
            return false;
        }
    }

    // VALIDATE USER (LOGIN) with Decryption check
    public User validateUser(String username, String password) {
        String query = "SELECT id, username, password, fullname FROM users WHERE username = ?";

        try (Connection conn = DBConfig.getDbConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                String storedHashedPassword = rs.getString("password");

                // 2. Use BCrypt to check if the plain text password matches the stored hash
                if (BCrypt.checkpw(password, storedHashedPassword)) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setFullname(rs.getString("fullname"));
                    return user;
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error during validation: " + e.getMessage());
        }

        return null; // Return null if password doesn't match or user not found
    }
    
    // Check if username exists (No changes needed here)
    public boolean isUsernameExists(String username) {
        String query = "SELECT id FROM users WHERE username = ?";

        try (Connection conn = DBConfig.getDbConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();

            return rs.next(); 

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}