/**
 * User management service for handling user operations
 * Provides CRUD operations and user validation
 */

import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class UserService {
    
    // User record with validation
    public record User(int id, String name, String email, Role role, boolean active) {
        public User {
            if (!isValidEmail(email)) {
                throw new IllegalArgumentException("Invalid email: " + email);
            }
        }
        
        private static boolean isValidEmail(String email) {
            String regex = "^[\\w.-]+@[\\w.-]+\\.\\w+$";
            return Pattern.matches(regex, email);
        }
    }
    
    public enum Role {
        ADMIN, USER, GUEST
    }
    
    // Result type for operations
    public sealed interface Result<T> permits Success, Failure {
        record Success<T>(T data) implements Result<T> {}
        record Failure<T>(String error) implements Result<T> {}
    }
    
    private final Map<Integer, User> users = new HashMap<>();
    private static final int MAX_USERS = 1000;
    
    public UserService() {
        initializeUsers();
    }
    
    /**
     * Initialize service with default users
     */
    private void initializeUsers() {
        List<User> defaultUsers = List.of(
            new User(1, "Alice", "alice@example.com", Role.ADMIN, true),
            new User(2, "Bob", "bob@example.com", Role.USER, true),
            new User(3, "Charlie", "charlie@example.com", Role.USER, false)
        );
        
        defaultUsers.forEach(user -> users.put(user.id(), user));
    }
    
    /**
     * Get user by ID
     * @param id The user's unique identifier
     * @return Result containing user or error message
     */
    public Result<User> getUser(int id) {
        User user = users.get(id);
        return user != null 
            ? new Result.Success<>(user)
            : new Result.Failure<>("User not found: " + id);
    }
    
    /**
     * Find users by role
     */
    public List<User> findByRole(Role role) {
        return users.values().stream()
            .filter(user -> user.role() == role && user.active())
            .collect(Collectors.toList());
    }
    
    /**
     * Create a new user
     */
    public Result<User> createUser(String name, String email, Role role) {
        if (users.size() >= MAX_USERS) {
            return new Result.Failure<>("Maximum user limit reached");
        }
        
        try {
            int id = users.keySet().stream()
                .max(Integer::compareTo)
                .orElse(0) + 1;
            
            User newUser = new User(id, name, email, role, true);
            users.put(id, newUser);
            return new Result.Success<>(newUser);
        } catch (IllegalArgumentException e) {
            return new Result.Failure<>(e.getMessage());
        }
    }
    
    public static void main(String[] args) {
        UserService service = new UserService();
        
        // Get user example
        Result<User> result = service.getUser(1);
        switch (result) {
            case Result.Success<User> success -> 
                System.out.println("Found: " + success.data().name());
            case Result.Failure<User> failure -> 
                System.err.println("Error: " + failure.error());
        }
        
        // Find admins
        List<User> admins = service.findByRole(Role.ADMIN);
        System.out.println("Admins: " + admins.size());
        
        // Create new user
        var createResult = service.createUser("Diana", "diana@example.com", Role.USER);
        System.out.println("Created: " + (createResult instanceof Result.Success));
    }
}
