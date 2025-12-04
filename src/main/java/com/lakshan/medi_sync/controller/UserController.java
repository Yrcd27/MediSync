package com.lakshan.medi_sync.controller;

import com.lakshan.medi_sync.entity.User;
import com.lakshan.medi_sync.service.UserService;
import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/users")
public class UserController {

    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/addUser")
    public ResponseEntity<User> addUser(@RequestBody User user){
        user.setPassword(DigestUtils.sha256Hex(user.getPassword()));
        userService.addNewUser(user);
        return ResponseEntity.status(201).body(user);
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody User user) {
        ResponseEntity<?> validationResponse = validateUserInput(user);

        if (validationResponse != null) {
            return validationResponse;
        }
        var dbUser = userService.getUserByEmail(user.getEmail());

        if (dbUser != null && dbUser.getPassword().equals(DigestUtils.sha256Hex(user.getPassword()))) {
            return ResponseEntity.ok(dbUser);
        } else
            return ResponseEntity.status(401).body("Invalid email or password");
    }

    private ResponseEntity<?> validateUserInput(User user) {
        if (user.getEmail() == null || user.getEmail().isBlank() ||
                user.getPassword() == null || user.getPassword().isBlank()) {
            return ResponseEntity.badRequest().body("Email and password must not be empty");
        }

        if (!user.getEmail().matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            return ResponseEntity.badRequest().body("Invalid email format");
        }
        return null;
    }
    @GetMapping("/getAllUsers")
    public List<User> getUsers(){
        return userService.getAllUsers();
    }

    @GetMapping("/getUser/{id}")
    public User getUser(@PathVariable int id){
        return userService.getUserById(id);
    }

    @PutMapping("/updateUser")
    public ResponseEntity<User> updateUser(@RequestBody User user){
        user.setPassword(DigestUtils.sha256Hex(user.getPassword()));
        userService.updateUser(user);
        return ResponseEntity.ok(user);
    }

    @DeleteMapping("/deleteUser/{id}")
    public void deleteUser(@PathVariable int id){
        userService.deleteUser(id);
    }

}
