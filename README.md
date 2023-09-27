[![Build and Test](https://github.com/evliu/TDDPractice-QuizApp-SwiftUI/actions/workflows/ci.yml/badge.svg)](https://github.com/evliu/TDDPractice-QuizApp-SwiftUI/actions/workflows/ci.yml)

# TDD Practice
This repo contains practice code for a Quiz app that utilizes a quiz engine based on tutorials. The engine was implemented first by adding failing tests, then making the tests pass by implementing the code.
## Quiz Engine
The quiz engine is in charge of the flow of the game and defining protocols and delegates that the consumers will need to implement.
## iOS Quiz App
The Quiz app utilizes the engine and provides the UI, the presenter, etc. It essentially wires up the app using what's provided by the engine.
