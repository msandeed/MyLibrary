import UIKit

var greeting = "Hello, playground"

func find(answers: [String], word: String) -> String? {
    var check = word
    var finalAnswer: String? = nil
    
    for answer in answers {
        var isPresent = true
        
        for char in check.enumerated() {
            if !check.contains(char.element) {
                isPresent = false
            } else {
                check = word.replacing
                print(check)
            }
        }
        
        if isPresent {
            finalAnswer = answer
            break
        }
        
    }
    
    return finalAnswer
}


let mm = find(answers: ["cat", "baby", "dog", "bird", "car", "ax"], word: "tcabnihjs")
let mmf = find(answers: ["cat", "baby", "dog", "bird", "car", "ax"], word: "tbcanihjs")
let mmd = find(answers: ["cat", "baby", "dog", "bird", "car", "ax"], word: "baykkjl")
let mms = find(answers: ["cat", "baby", "dog", "bird", "car", "ax"], word: "bbabylkkj")
let mmg = find(answers: ["cat", "baby", "dog", "bird", "car", "ax"], word: "ccc")
let mmthg = find(answers: ["cat", "baby", "dog", "bird", "car", "ax"], word: "breadmaking")
