//
//  MusicPlayerDataProvider.swift
//  MusicPlayer
//
//  Created by Alexey on 8/7/17.
//  Copyright © 2017 Alexey Zhilnikov. All rights reserved.
//

import UIKit
import AVFoundation

class MusicPlayerDataProvider: NSObject {
    
    weak var delegate: MusicPlayerDataProviderDelegate?
    fileprivate(set) var lastSelectedRow: Int?
    
    fileprivate var shouldPause = false
    fileprivate let cellDataProvider = ArtistRecordCellDataProvider()
    fileprivate let musicPlayer = MusicPlayer()
    
    override init() {
        super.init()
        musicPlayer.delegate = self
    }
    
    // Fetch data from iTunes, where name - is an artist name
    func fetch(_ name: String, completion: @escaping (MusicPlayerResult) -> Void) {
        
        musicPlayer.stop(shouldPause: false)
        delegate?.didFinishPlaying()
        
        let artistName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        let service = MusicPlayerAPIService()
        
        // Clear previos data
        cellDataProvider.clear()
        lastSelectedRow = nil
        
        service.fetch(artistName) { [weak self] (data, result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    do {
                        try self?.cellDataProvider.parse(jsonData: data)
                        completion(.success)
                    } catch {
                        completion(.failure("Invalid JSON data"))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func prepareToPause() {
        // Pause player instead of stopping
        shouldPause = true
    }
    
    fileprivate func startPlayingSong(_ song: Data?, at row: Int) {
        cellDataProvider[row].status = .playing
        musicPlayer.play(song)
    }
}

extension MusicPlayerDataProvider: MusicPlayerDelegate {
    func playerDidFinishPlaying() {
        delegate?.didFinishPlaying()
    }
}

extension MusicPlayerDataProvider: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataProvider.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MusicPlayerCell",
                                                    for: indexPath) as? MusicPlayerTableViewCell {
            let record = cellDataProvider[indexPath.row]
            
            cell.record = record.artistRecord
            cell.status = record.status
            
            // Set image if it already exists or download image using url
            if let imageData = record.imageData {
                cell.imageData = imageData
            } else if nil == record.imageTask, let url = URL(string: record.artistRecord.imageURL) {
                
                // Download image using image url
                let session = URLSession(configuration: .default)
                
                record.imageTask = session.dataTask(with: url) { (data, response, error) in
                    record.imageData = data
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }
                record.imageTask?.resume()
            }
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let record = cellDataProvider[indexPath.row]
        
        // Cancel image downloading if the task it is still running
        if let imageTask = record.imageTask, .running == imageTask.state {
            imageTask.cancel()
            record.imageTask = nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let row = lastSelectedRow {
            if row != indexPath.row {
                // Update status of the previously selected record, if different cell was selected
                cellDataProvider[row].status = .stopped
                // Tell delegate that new cell has been selected
                delegate?.didSelectCell(oldCellRow: lastSelectedRow)
            }
        } else {
            // Cell has been seleceted for the first time
            // Tell delegate to show music player view (Play/Pause button)
            delegate?.didSelectCell(oldCellRow: lastSelectedRow)
        }
        
        lastSelectedRow = indexPath.row
        
        let record = cellDataProvider[indexPath.row]
        
        // Do not stop player if the same cell was previously paused
        // Player will resume current song
        if .paused != record.status {
            musicPlayer.stop(shouldPause: false)
        }
        
        let cell = tableView.cellForRow(at: indexPath) as? MusicPlayerTableViewCell
        
        if let songData = record.songData {
            // Song data has been downloaded, update cell status and play song
            cell?.status = .playing
            startPlayingSong(songData, at: indexPath.row)
        } else if nil == record.songTask, let url = URL(string: record.artistRecord.songURL) {
            // Download song data using song url
            let session = URLSession(configuration: .default)
            record.songTask = session.dataTask(with: url) { [weak self] (data, response, error) in
                record.songData = data
                DispatchQueue.main.async { [weak self] in
                    // Song data has been downloaded, update cell status and play song
                    cell?.status = .playing
                    self?.startPlayingSong(data, at: indexPath.row)
                }
            }
            record.songTask?.resume()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // Update record status
        let record = cellDataProvider[indexPath.row]
        record.status = shouldPause ? .paused : .stopped
        
        // Cancel song downloading if the task it is still running
        if let songTask = record.songTask, .running == songTask.state {
            songTask.cancel()
            record.songTask = nil
        }
        
        // Change cell status if cell still exists (visible cell)
        let cell = tableView.cellForRow(at: indexPath) as? MusicPlayerTableViewCell
        cell?.status = shouldPause ? .paused : .stopped
        
        // Stop or pause player
        musicPlayer.stop(shouldPause: shouldPause)
        shouldPause = false
    }
}
