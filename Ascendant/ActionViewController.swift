//
//  ActionViewController.swift
//  Ascendant
//
//  Created by Kyle Bashour on 2/23/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import UIKit
import EXTView

class ActionViewController: UIViewController {
    
    
    @IBOutlet weak var passButton: EXTButton!
    @IBOutlet weak var failButton: EXTButton!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var game: Game!
    var action = Action.missionVote
    var players: [Player]!
    var numberOfPlayersForProposal = 0
    
    var actionMessage: String {
        switch action {
        case .proposeMission: return "Select \(numberOfPlayersForProposal) Players for a Mission"
        case .proposalVote: return "Approve Players for a Mission"
        case .missionVote: return "Pass the Mission?"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    func setUpUI() {
        
        navigationItem.title = actionMessage
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        switch action {
        case .proposeMission:
            failButton.hidden = true
            passButton.setTitle("Propose", forState: .Normal)
            passButton.backgroundColor = UIColor.asc_blueColor()
            passButton.enabled = false
        case .proposalVote:
            passButton.setTitle("Approve", forState: .Normal)
            failButton.setTitle("Deny", forState: .Normal)
        case .missionVote:
            passButton.setTitle("Pass", forState: .Normal)
            failButton.setTitle("Fail", forState: .Normal)
        }
        
        
        // THEME
        
        view.backgroundColor = UIColor.asc_baseColor()
        tableView.separatorColor = UIColor.asc_separatorColor()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       if let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.playerCell) {
           return configurePlayerCell(cell, forIndexPath: indexPath)
        }
        
        assertionFailure("Unable to dequeue a player cell")
        
        return UITableViewCell()
    }
    
    func configurePlayerCell(cell: PlayerCell, forIndexPath indexPath: NSIndexPath) -> PlayerCell {
        
        let player = players[indexPath.row]
        
        cell.nameLabel.text = player.name
        cell.teamView.backgroundColor = UIColor.asc_transparentWhiteColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        // We can only select cells if we're proposing a mission
        guard action == .proposeMission else {
            return nil
        }
        
        // Only allow them to select the maximum needed (rethinking this, hence the comment out)
//        guard tableView.indexPathsForSelectedRows?.count < numberOfPlayersForProposal else {
//            return nil
//        }
//        
        // Okay, we can select this!
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? PlayerCell else {
            return
        }
        
        let player = players[indexPath.row]

        passButton.enabled = tableView.indexPathsForSelectedRows?.count == numberOfPlayersForProposal
        cell.accessoryType = .Checkmark

        if game.player.team == .bad {
            cell.teamView.backgroundColor = player.teamColor
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? PlayerCell else {
            return
        }
        
        passButton.enabled = tableView.indexPathsForSelectedRows?.count == numberOfPlayersForProposal
        cell.accessoryType = .None
        cell.teamView.backgroundColor = UIColor.asc_transparentWhiteColor()
    }
    
    @IBAction func votePressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

enum Action {
    case proposeMission
    case proposalVote
    case missionVote
}
