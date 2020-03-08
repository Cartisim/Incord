//
//  ChannelImage.swift
//  Incord
//
//  Created by Cole M on 7/12/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

struct ChannelImage: Codable {
    var id: Int?
    var image: Data
    
    init(image: Data) {
        self.image = image
    }
    
    func deleteImage(id: Int, completion: @escaping (PassFailResult) -> Void) {
        guard let url = URL(string: "\(CHANNEL_URL)/image/\(id)/channelImage") else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
         request.addValue("Bearer \(UserData.shared.token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 {
                print(httpResponse.statusCode)
                completion(.success)
            } else {
                completion(.failure)
            }
        }.resume()
    }
}
