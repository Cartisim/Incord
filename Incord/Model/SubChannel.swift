//
//  SubChannel.swift
//  Incord
//
//  Created by Cole M on 6/27/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

final class SubChannel: Codable {
    
    var id: Int?
    var title: String
    var channelID: Int
    
    init(id: Int?, title: String, channelID: Int) {
        self.id = id
        self.title = title
        self.channelID = channelID
    }
    
    func deleteSubChannel(id: Int, completion: @escaping (PassFailResult) -> Void) {
        guard let url = URL(string: "\(BASE_URL)/sub_channel/\(id)") else {return}
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
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

