//
//  Theory.swift
//  DraftSwiftUI
//
//  Created by Mostafa Sandeed on 01/02/2024.
//

// In Swift concurrency, functions would run on global executers unless told otherwise
// Await is not a blocking operation
// Structured concurrency is achieved through async let OR Task Groups
// Task.detached is not the way to run tasks away from main actor. That's actually the default. It is useful when you want to fire off a background task without tying it to the lifespan of the surrounding function or scope.
// SwiftUI Views with observable objects are implicitly @MainActor
// We do not manage weak/strong references inside Tasks because we can manage the Task itself
