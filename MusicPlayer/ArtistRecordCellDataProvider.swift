//
//  ArtistRecordCellDataProvider.swift
//  MusicPlayer
//
//  Created by Alexey on 10/7/17.
//  Copyright © 2017 Alexey Zhilnikov. All rights reserved.
//

import Foundation

class ArtistRecordCellDataProvider {
    
    subscript(index: Int) -> ArtistRecordCellData {
        get {
            return cellRecords[index]
        }
        set {
            cellRecords[index] = newValue
        }
    }
    
    var count: Int {
        return cellRecords.count
    }
    
    private var cellRecords = [ArtistRecordCellData]()
    
    // Parse JSON object received from the server
    func parse(jsonData: Data?) throws {
        
        // Clear all previous records
        self.clear()
        
        guard let data = jsonData,
            let json = try? JSONSerialization.jsonObject(with: data,
                                                         options: .allowFragments) as? [String: Any] else {
            throw MusicPlayerResult.failure("Invalid JSON data")
        }
        
        guard let results = json?["results"] as? [[String: Any]] else {
            throw MusicPlayerResult.failure("Invaild JSON data")
        }
        
        for result in results {
            // Parse artist related JSON data
            if let record = ArtistRecord(json: result) {
                cellRecords.append(ArtistRecordCellData(record: record))
            }
        }
    }
    
    func clear() {
        cellRecords.removeAll()
    }
}
