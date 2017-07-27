//
//  MusicPlayerViewController.swift
//  MusicPlayer
//
//  Created by Alexey on 8/7/17.
//  Copyright © 2017 Alexey Zhilnikov. All rights reserved.
//

import UIKit

class MusicPlayerViewController: UIViewController {

    @IBOutlet fileprivate var musicPlayerTableView: UITableView!
    @IBOutlet fileprivate var musicPlayerView: MusicPlayerView!
    
    fileprivate let dataProvider = MusicPlayerDataProvider()
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup table view
        musicPlayerTableView?.dataSource = dataProvider
        musicPlayerTableView?.delegate = dataProvider
        musicPlayerTableView?.estimatedRowHeight = 125
        musicPlayerTableView?.rowHeight = UITableViewAutomaticDimension
        
        // Setup search controller
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search artist"
        searchController.searchBar.keyboardType = .default
        searchController.searchBar.autocapitalizationType = .words
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.delegate = self
        
        dataProvider.delegate = self
        musicPlayerView?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension MusicPlayerViewController: UISearchBarDelegate {
    
    // MARK: - Search bar delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let artistName = searchBar.text else { return }
        searchController.isActive = false
        
        self.dataProvider.fetch(artistName) {
            [weak self] (result) in
            switch result {
            case .success:
                self?.musicPlayerTableView.isHidden = false
                self?.musicPlayerTableView.reloadData()
                
            case .failure(let error):
                self?.musicPlayerTableView.isHidden = true
                self?.showAlert(title: "Error", message: error)
            }
        }
    }
}

extension MusicPlayerViewController: MusicPlayerDataProviderDelegate {
    
    // MARK: - Music player data provider delegates
    
    func didSelectCell(oldCellRow: Int?) {
        if !musicPlayerView.isVisible {
            // Show player view with Play/Pause button
            musicPlayerView.show()
        }
        
        if let row = oldCellRow {
            // Stop playing previos record
            dataProvider.tableView(musicPlayerTableView,
                                   didDeselectRowAt: IndexPath(row: row, section: 0))
        }
        
        // Update Play/Pause button
        musicPlayerView.isPlaying = true
    }
    
    func didFinishPlaying() {
        if let row = dataProvider.lastSelectedRow {
            // Update cell (stop animation)
            dataProvider.tableView(musicPlayerTableView,
                                   didDeselectRowAt: IndexPath(row: row, section: 0))
        }
        // Update Play/Pause button
        musicPlayerView.isPlaying = false
    }
}

extension MusicPlayerViewController: MusicPlayerViewDelegate {
    
    // MARK: - Music player view delegates
    
    func didPlayButtonTapped() {
        if let row = dataProvider.lastSelectedRow {
            // Continue playing the same song (resume)
            dataProvider.tableView(musicPlayerTableView,
                                   didSelectRowAt: IndexPath(row: row, section: 0))
        }
    }
    
    func didPauseButtonTapped() {
        if let row = dataProvider.lastSelectedRow {
            dataProvider.prepareToPause()
            // Pause song, update cell status
            dataProvider.tableView(musicPlayerTableView,
                                   didDeselectRowAt: IndexPath(row: row, section: 0))
        }
    }
}
