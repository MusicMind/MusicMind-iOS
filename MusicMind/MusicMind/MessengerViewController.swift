//
//  MessengerViewController.swift
//  MusicMind
//
//  Created by Alec Arshavsky on 5/4/17.
//  Copyright © 2017 Alec Arshavsky. All rights reserved.
//


import UIKit
import Foundation
import CoreData

class MessengerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    
    
    
    @IBOutlet var messagesList: UITableView!
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var formBackBar: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageForm: UITextField!
    
    
    let cellID = ["IncomingCell", "OutgoingCell"]
    
    var messages: [Message]! = []
    var conversations = [Conversation]()
    
    var convID : Int64!
    var conversation : Conversation!
    
    var messagesDisplayed = 0
    let ownID: String! = UserDefaults.standard.string(forKey: "userID")
    var numMes: Int! = 0
    var timer : Timer?
    
    
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    func loadConversation() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Conversation")
        
        // Create a sort descriptor object that sorts based on timeAgo posted
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: true)
        
        // Set the list of sort descriptors in the fetch request, so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        // Create a new predicate that filters out any conversation other than the current one
        let predicate = NSPredicate(format: "conversationID == %@", String(convID))
        
        // Set the predicate on the fetch request
        fetchRequest.predicate = predicate
        
        if let fetchResults = (try? managedObjectContext.fetch(fetchRequest)) as? [Conversation] {
            conversations = fetchResults
        }
        
        if conversations.count == 0 {
            presentingViewController?.dismiss(animated: true, completion: nil)
        } else if conversations.count == 1 {
            
            // Get the last message (for use in message previews on previous screen)
            let pMes: [Message]! = conversations[0].messages
            let mes: Message! = pMes[pMes.count-1]
            
            // ************************  Extract Conversation Info ****************************************************
        }
    }
    
    
    func checkNewMessages(_ timer: Timer) {
        loadMessages()
    }
    
    
    
    func loadMessages() {
        fetchCache()
        if numMes < Int(conversations[0].messageNum) {
            messages = conversations[0].messages
            numMes = Int(conversations[0].messageNum)
            cacheReadStatus()
            self.messagesList.reloadData()
        }
    }
    
    
    func appendToCache (_ message: Message) {
        message.status = 2
        messages.append(message)
        conversations[0].messages = messages
        numMes = numMes+1
        conversations[0].messageNum = Int16(numMes)
        conversations[0].timeStamp = message.timeStamp
        // Save conversation instead of former conversation
        save()
        
    }
    
    
    func cacheReadStatus () {
        for row in 0...messages.count-1 {
            messages[row].status = 2
        }
        conversations[0].messages = messages
        // Save conversation instead of former conversation
        save()
    }
    
    
    func fetchCache() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Conversation")
        
        // Create a sort descriptor object that sorts based on timeAgo posted
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: true)
        
        // Set the list of sort descriptors in the fetch request, so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        // Create a new predicate that filters out any conversation other than the current one
        let predicate = NSPredicate(format: "conversationID == %@", String(self.convID))
        
        // Set the predicate on the fetch request
        fetchRequest.predicate = predicate
        
        if let fetchResults = (try? self.managedObjectContext.fetch(fetchRequest)) as? [Conversation] {
            self.conversations = fetchResults
        }
        
    }
    
    
    func save() {
        do {
            try managedObjectContext.save()
        } catch {
            // let nserror = error as NSError
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        messagesList.backgroundColor = UIColor.clear
        messagesList.tableFooterView = UIView(frame: CGRect.zero)
        messagesList.estimatedRowHeight = 72
        messagesList.rowHeight = UITableViewAutomaticDimension
        
        messagesList.delegate = self
        messagesList.dataSource = self
        messageForm.delegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(MessengerViewController.checkNewMessages(_:)), userInfo: nil, repeats: true)
        
        loadMessages()
        
        
        partnerLabel.text = conversation.partnerName
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessengerViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessengerViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        // Reload the table
        self.messagesList.reloadData()
        
        // Scroll down
        let delay = 0.01 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.messagesList.scrollToRow(at: indexPath, at: .bottom, animated: true)
            
        })
    }
    
    
    
    
    
    
    fileprivate var messageFormText = ""
    
    @IBAction func MessageFormChanged(_ sender: UITextField) {
        messageFormText = sender.text!
        if messageFormText == "" {
            sendButton.isHidden = true
        } else {
            sendButton.isHidden = false
        }
    }
    
    
    @IBAction func SendButtonDidTouch(_ sender: AnyObject) {
        view.endEditing(true)
        
        if messageFormText != "" {
            let messageDate = Int64(Date().timeIntervalSinceReferenceDate*1000)
            let messageStatus = 2
            let messageSender = ownID
            let messageConvID = Int(conversations[0].conversationID)
            let messageID = 0
            
            let message = Message(text: messageFormText, timeStamp: messageDate, status: Int32(messageStatus), sender: messageSender!, messageID: Int64(messageID))
            
            // ********************************************* Send Message through Network ****************************
            
            messageForm.text = ""
            MessageFormChanged(messageForm)
            appendToCache(message)
            self.messagesList.reloadData()
            
        }
    }
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    // Moves TableView up while editing so that fields are visible
    func keyboardWillShow(_ notification: Notification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height
            
            // Scroll down
            let delay = 0.1 * Double(NSEC_PER_SEC)
            let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                
                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                self.messagesList.scrollToRow(at: indexPath, at: .bottom, animated: true)
                
            })
            
        })
        
    }
    
    func keyboardWillHide(_ notification : Notification) {
        self.bottomConstraint.constant = 0
    }
    
    
    
        
    
    
    // Dictates what happens when back button is pressed.
    @IBAction func backButtonDidTouch(_ sender: AnyObject) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // MARK: - TABLE VIEW FUNCTIONS
    
    // Number of sections in the tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows per section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    // Dequeue reusable cells, if none exist create the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        // pull item from JSON
        let messageData = messages[row]
        let text = messageData.text
        let sender = messageData.sender
        
        
        // If unread send read status to Server  *********************
        
        
        if sender == ownID {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID[1], for: indexPath) as! OutgoingTableViewCell
            
            // All the properties of the cell
            cell.messageLabel.text = text
            cell.tag = row
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID[0], for: indexPath) as! IncomingTableViewCell
            
            // All the properties of the cell
            cell.messageLabel.text = text
            cell.tag = row
            return cell
        }
        
    }
    
    
    
    // Dictates what happens when the item is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        view.endEditing(true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
   
    
}
