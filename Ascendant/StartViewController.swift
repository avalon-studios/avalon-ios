//
//  StartViewController.swift
//  Ascendant
//
//  Created by Kyle Bashour on 2/22/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UITableViewDataSource, PlayerUpdatable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonContainerView: UIView!
    
    var game: Game!
    var players = [Player]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        players = game.players
        game.playerUpdatable = self
        tableView.reloadData()
        navigationItem.title = "Room Code: \(game.id.uppercaseString)"
        
        setUpUI()
    }
    
    func setUpUI() {
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.dataSource = self
        
        view.backgroundColor = UIColor.asc_baseColor()
    }
    
    @objc func reloadTableView() {
        tableView.reloadData()
    }
    
    @IBAction func joinGamePressed(sender: UIButton) {
        beginGame()
    }
    
    func beginGame() {
        
        let gameViewController = R.storyboard.gamePlay.initialViewController()!
        
        Socket.manager.game = game
        gameViewController.game = game
        
        dismissViewControllerAnimated(true) {
            self.presentingViewController?.presentViewController(gameViewController, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.players.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.welcomePlayerCell) else {
            fatalError("Unable to deque a welcome player cell")
        }
        
        cell.nameLabel.text = game.players[indexPath.row].name
        
        return cell
    }
    
    func updatePlayers(players: [Player]) {
        self.players = players
        tableView.reloadData()
    }
}
 