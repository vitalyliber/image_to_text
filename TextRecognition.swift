//
//  TextRecognition.swift
//  image_to_text
//
//  Created by Vitaliy Liber on 13.08.2023.
//


import Foundation
import Vision
import CoreImage

func recognizeTextOnImage(fileName: String) {
    guard let imageUrl = Bundle.main.url(forResource: fileName, withExtension: nil),
          let ciImage = CIImage(contentsOf: imageUrl),
          let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else {
        print("Failed to load or convert image from path")
        return
    }

    let request = VNRecognizeTextRequest { request, error in
        if let error = error {
            print("Error recognizing text: \(error)")
            return
        }
        
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        var recognizedText = ""
        for observation in observations {
            guard let topCandidate = observation.topCandidates(1).first else {
                continue
            }
            recognizedText += topCandidate.string + "\n"
        }
        
        if !recognizedText.isEmpty {
            print(recognizedText)
        }
    }

    let requests = [request]
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

    do {
        try handler.perform(requests)
    } catch {
        print("Error performing recognition request: \(error)")
    }
}

// Пример использования:
//let imageName = "codeimage.jpeg"
//recognizeTextOnImage(fileName: imageName)

// Получаем аргументы командной строки
let arguments = CommandLine.arguments

// Проверяем, что есть хотя бы один аргумент (имя файла)
if arguments.count < 2 {
    print("Usage: \(arguments[0]) <image_file_name>")
} else {
    let imageName = arguments[1]
    recognizeTextOnImage(fileName: imageName)
}

// How to compile:
// swiftc -o TextRecognition TextRecognition.swift

// How to use:
// ./TextRecognition your_image_name_here.png
