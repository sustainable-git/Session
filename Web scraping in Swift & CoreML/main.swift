//
//  main.swift
//  Web scraping
//
//  Created by Shin Jae Ung on 2022/05/19.
//

import Foundation
import SwiftSoup

enum FetchError: Error {
    case error
}

func fetchGoogleImageURLs(searchWord: String, completion: @escaping (Result<[String], Error>) -> Void) {
    let baseURL: String = "https://www.google.com/search?tbm=isch&q="
    let searchPath: String = searchWord.replacingOccurrences(of: " ", with: "%20")
    guard let url = URL(string: baseURL + searchPath) else {
        completion(.failure(FetchError.error))
        return
    }
    do {
        var resultURLs: [String] = []

        let contents: String = try String(contentsOf: url)
        let document: Document = try SwiftSoup.parse(contents)

        let links = try document.getElementsByClass("yWs4tf")
        for link in links {
            let element = try link.select("img")
            let imageURL = try element.attr("src")
            resultURLs.append(imageURL)
        }
        completion(.success(resultURLs))
    } catch {
        completion(.failure(FetchError.error))
    }
}

class FileSaveManager: NSObject, URLSessionDownloadDelegate {
    var urlSession: URLSession {
        URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    let uniqueIDFactory: () -> Int
    private static func uniqueIDFactory() -> () -> Int {
        var id = 0
        func uniqueNumber() -> Int {
            id += 1
            return id
        }
        return uniqueNumber
    }

    override init() {
        self.uniqueIDFactory = FileSaveManager.uniqueIDFactory()
        super.init()
    }
    
    func downloadTask(url: URL) {
        self.urlSession.downloadTask(with: url).resume()
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let desktopURL = try? FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return }

        let destinationURL = desktopURL.appendingPathComponent("\(uniqueIDFactory())").appendingPathExtension("jpeg")
        try? FileManager.default.removeItem(at: destinationURL)
        try? FileManager.default.moveItem(at: location, to: destinationURL)
    }
}

let fileSaveManager = FileSaveManager()
fetchGoogleImageURLs(searchWord: "spider man") { result in
    switch result {
    case .success(let arr):
        arr.forEach {
            guard let url = URL(string: $0) else { return }
            fileSaveManager.downloadTask(url: url)
        }
    case .failure(let error):
        print(error)
    }
}
RunLoop.current.run(until: .now + 5)
