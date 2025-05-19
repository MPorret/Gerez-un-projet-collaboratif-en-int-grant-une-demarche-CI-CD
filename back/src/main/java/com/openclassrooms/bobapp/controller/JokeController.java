package com.openclassrooms.bobapp.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.openclassrooms.bobapp.service.JokeService;

@RestController
@RequestMapping("api/joke")
public class JokeController {

    private final JokeService jokeService;

    JokeController(JokeService jokeService) {
        this.jokeService = jokeService;
    }

    @GetMapping()
    public ResponseEntity<?> getRandomJokes() {
        return ResponseEntity.ok(this.jokeService.getRandomJoke());
    }

    @GetMapping("/two")
    public ResponseEntity<List<String>> GetTwoRandomJokes() {
        return ResponseEntity.ok(List.of(this.jokeService.getRandomJoke(), this.jokeService.getRandomJoke()));
    }
}
