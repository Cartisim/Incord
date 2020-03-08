//
//  Channel.swift
//  Incord
//
//  Created by Cole M on 6/27/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

final class Channel: Codable {
    
    var id: Int?
    var imageString: String
    var channel: String
    
    init(id: Int, imageString: String, channel: String) {
        self.id = id
        self.imageString = imageString
        self.channel = channel
    }
    
    func deleteChannel(id: Int, completion: @escaping (PassFailResult) -> Void) {
           guard let url = URL(string: "\(BASE_URL)/channel/\(id)") else {return}
           var request = URLRequest(url: url)
           request.httpMethod = "DELETE"
           request.addValue("Bearer \(UserData.shared.token)", forHTTPHeaderField: "Authorization")
           print(request)
           URLSession.shared.dataTask(with: request) { (_, response, _) in
               if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 {
                   print(httpResponse.statusCode)
                   completion(.success)
               } else {
                   completion(.failure)
               }
               }.resume()
       }

}
