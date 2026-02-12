# Common Spring Boot Errors & Solutions

## 1. Connection is read-only — INSERT blocked by `@Transactional(readOnly = true)`

### Error

```
java.sql.SQLException: Connection is read-only. Queries leading to data modification are not allowed
```

Full stack trace shows:
```
org.springframework.orm.jpa.JpaSystemException: could not execute statement
[Connection is read-only. Queries leading to data modification are not allowed]
[/* insert for com.codemania.criteriaapi.model.User */insert into users (...) values (...)]
```

### Cause

The service class had `@Transactional(readOnly = true)` at the **class level**, which makes every method read-only by default. The write method (`createNewUser`) inherited this and MySQL rejected the INSERT.

```java
@Service
@Transactional(readOnly = true)  // <-- All methods become read-only
public class UserService {

    // Read methods work fine...

    public User createNewUser(UserRequest newUser) {
        return userRepository.save(createdUser);  // FAILS - read-only connection
    }
}
```

### Solution

Add `@Transactional` (without `readOnly`) on write methods to override the class-level default:

```java
@Service
@Transactional(readOnly = true)  // Good default for query-heavy services
public class UserService {

    @Transactional  // Overrides to readOnly=false for this method
    public User createNewUser(UserRequest newUser) {
        return userRepository.save(createdUser);  // Works now
    }
}
```

### Key Takeaway

Method-level `@Transactional` overrides class-level. Use `readOnly = true` at the class level as a performance optimization for read-heavy services, and override individual write methods.

---

## 2. Jackson Deserialization Fails — Missing No-Arg Constructor with Lombok `@Builder`

### Error

```
tools.jackson.databind.exc.InvalidDefinitionException:
Cannot construct instance of `com.distributedsystem.restclient.User`
(no Creators, like default constructor, exist):
cannot deserialize from Object value (no delegate- or property-based Creator)
```

### Cause

The `User` class only had `@Builder`, which generates a private all-args constructor but **no no-arg constructor**. Jackson needs a no-arg constructor to deserialize JSON into an object.

```java
@Getter
@Setter
@Builder  // Only generates builder + private all-args constructor
public class User {
    private String username;
    private String email;
    private Boolean active;
}
```

### Solution

Add `@NoArgsConstructor` and `@AllArgsConstructor`:

```java
@Getter
@Setter
@Builder
@NoArgsConstructor   // Jackson needs this for deserialization
@AllArgsConstructor  // @Builder needs this when @NoArgsConstructor is present
public class User {
    private String username;
    private String email;
    private Boolean active;
}
```

### Why Both Are Needed

- `@NoArgsConstructor` — gives Jackson its empty constructor
- `@AllArgsConstructor` — required because `@Builder` depends on an all-args constructor, and `@NoArgsConstructor` causes Lombok to stop generating the implicit one

### Alternative

Use `@Jacksonized` with `@Builder` to let Jackson use the builder pattern directly for deserialization (no no-arg constructor needed):

```java
@Getter
@Builder
@Jacksonized
public class User { ... }
```
