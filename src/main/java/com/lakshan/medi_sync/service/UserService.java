package com.lakshan.medi_sync.service;

import com.lakshan.medi_sync.entity.User;
import com.lakshan.medi_sync.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    private final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public void addNewUser(User user) {
        userRepository.save(user);
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User getUserById(int id) {
        return userRepository.findById(id).orElseThrow(() ->
                new IllegalArgumentException("User not found with id: " + id)
        );
    }

    public void updateUser(User user){
        if(userRepository.existsById(user.getId()))
            userRepository.save(user);
        else
            throw new IllegalArgumentException("User not found with id: " + user.getId());
    }

    public void deleteUser(int id){
        if(userRepository.existsById(id))
            userRepository.deleteById(id);
        else
            throw new IllegalArgumentException("User not found with id: " + id);
    }

    public User getUserByEmail(String email) {
        return userRepository.findByEmail(email).orElseThrow(() ->
                new IllegalArgumentException("User not found with email: " + email)
        );

    }
}
