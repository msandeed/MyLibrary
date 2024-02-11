//
//  FacadePattern.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 12/02/2024.
//

import Foundation

// Subsystem components
class Engine {
    func start() {
        print("Engine started")
    }

    func stop() {
        print("Engine stopped")
    }
}

class Lights {
    func turnOn() {
        print("Lights turned on")
    }

    func turnOff() {
        print("Lights turned off")
    }
}

class AirConditioner {
    func turnOn() {
        print("Air conditioner turned on")
    }

    func turnOff() {
        print("Air conditioner turned off")
    }
}

// Facade
class CarFacade {
    private let engine: Engine
    private let lights: Lights
    private let airConditioner: AirConditioner

    init() {
        self.engine = Engine()
        self.lights = Lights()
        self.airConditioner = AirConditioner()
    }

    // Simplified methods for starting and stopping the car
    func startCar() {
        engine.start()
        lights.turnOn()
        airConditioner.turnOn()
        print("Car started")
    }

    func stopCar() {
        engine.stop()
        lights.turnOff()
        airConditioner.turnOff()
        print("Car stopped")
    }
}
