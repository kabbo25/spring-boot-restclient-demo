package com.distributedsystem.restclient.controller;

import com.distributedsystem.restclient.User;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestClient;

import java.util.LinkedHashMap;
import java.util.List;

@RestController
public class ResetController {


    RestClient restClient = RestClient.create();

    @GetMapping("/")
    public ResponseEntity<?> getAllActiveUsers(){
        List<?> response = restClient
                .get()
                .uri("http://localhost:8080/api/users/active")
                .header("Authorization", "Bearer eyefafdadfajdfjadfja")  // Correct header format
                .retrieve()
                .body(List.class);
        assert response != null;
        System.out.println(((LinkedHashMap<?, ?>) response.get(0)));
        return ResponseEntity.ok(response);
    }
}
