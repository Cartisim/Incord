//
//  NSImage.swift
//  Incord
//
//  Created by Cole M on 8/27/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Cocoa

//extension NSImageView {
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = NSImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//
//}


extension NSImageView {
    func load(url: URL) {
        let token = UserData.shared.token
        DispatchQueue.global().async { [weak self] in
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let task = session.dataTask(with: request) {data, response, error in
                if error != nil || data == nil {
                debugPrint("Client error!")
                return
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {                     debugPrint("Server error!")
                    return
                }
                guard let d = data else {
                    debugPrint("error, data was nil from \(url)")
                    return
                }
//                guard let mime = response.mimeType, mime == "application/json" else {
//                    print("Wrong MIME type!")
//                    return
//                }
                if let image = NSImage(data: d) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
            task.resume()
        }
    }
}

