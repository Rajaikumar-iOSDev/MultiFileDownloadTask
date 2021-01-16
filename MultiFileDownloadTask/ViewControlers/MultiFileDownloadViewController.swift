//
//  ViewController.swift
//  MultiFileDownloadTask
//
//  Created by Subburaman, Rajai Kumar on 13/08/19.
//  Copyright © 2019 Subburaman, Rajai Kumar. All rights reserved.
//

import UIKit
import MZDownloadManager
class MultiFileDownloadViewController: UIViewController {
    // MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    // MARK:- Properties
    var urlArray = [String]()
    let myDownloadPath = MZUtility.baseFilePath + "/Downloads"
    lazy var downloadManager: MZDownloadManager = {
        [unowned self] in
        let randomNumber = Int.random(in: 100000 ... 999999)
        let sessionIdentifer: String = "com.MultiFileDownload.BackgroundSession.download." + String(describing: randomNumber)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var completion = appDelegate.backgroundSessionCompletionHandler
        
        let downloadmanager = MZDownloadManager(session: sessionIdentifer, delegate: self, completion: completion)
        return downloadmanager
        
    }()
    
    
    // MARK:- ViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        // Do any additional setup after loading the view.
        setUsername()
        setDownloadTask()
        
        
        
    }
    
    
    
}

// MARK:- Support Methods
extension MultiFileDownloadViewController{
    
    fileprivate func setDownloadTask() {
        for url in urlArray{
            let fileURL  : NSString = url as NSString
            var fileName : NSString = fileURL.lastPathComponent as NSString
            fileName = MZUtility.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(fileName as String) as NSString)
            
            downloadManager.addDownloadTask(fileName as String, fileURL: fileURL as String, destinationPath: myDownloadPath)}
    }
    
    fileprivate func setUsername() {
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        userNameLabel.text=name
    }
    
    func refreshCellForIndex(_ downloadModel: MZDownloadModel, index: Int) {
        let indexPath = IndexPath.init(row: index, section: 0)
        
        let cell = self.tableView.cellForRow(at: indexPath)
        if let cell = cell {
            let downloadCell = cell as! FileDownloadCell
            downloadCell.updateCellForRowAtIndexPath(indexPath, downloadModel: downloadModel)
        }
        
        
    }
    
    @objc func downloadCancelAction(_ sender: UIButton) {
        let numberOfRows = tableView.numberOfRows(inSection:0)
        if numberOfRows == 2{
            
            self.downloadManager.cancelTaskAtIndex(sender.tag)}else{
                
                self.downloadManager.cancelTaskAtIndex(0)
            }
    }}


// MARK:- MZDownloadManagerDelegate
extension MultiFileDownloadViewController: MZDownloadManagerDelegate {
    func downloadRequestStarted(_ downloadModel: MZDownloadModel, index: Int) {
        let indexPath = IndexPath.init(row: index, section: 0)
        if let _ = tableView{
            tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)}
    }
    
    func downloadRequestDidPopulatedInterruptedTasks(_ downloadModels: [MZDownloadModel]) {
        tableView.reloadData()
    }
    
    func downloadRequestDidUpdateProgress(_ downloadModel: MZDownloadModel, index: Int) {
        self.refreshCellForIndex(downloadModel, index: index)
    }
    
    
    func downloadRequestDidPaused(_ downloadModel: MZDownloadModel, index: Int) {
        self.refreshCellForIndex(downloadModel, index: index)
    }
    
    func downloadRequestDidResumed(_ downloadModel: MZDownloadModel, index: Int) {
        self.refreshCellForIndex(downloadModel, index: index)
    }
    
    func downloadRequestCanceled(_ downloadModel: MZDownloadModel, index: Int) {
        
        let indexPath = IndexPath.init(row: index, section: 0)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
    }
    
    func downloadRequestFinished(_ downloadModel: MZDownloadModel, index: Int) {
        
        downloadManager.presentNotificationForDownload("Ok", notifBody: "Download did completed")
        let indexPath = IndexPath.init(row: index, section: 0)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
        let docDirectoryPath : NSString = (MZUtility.baseFilePath as NSString).appendingPathComponent(downloadModel.fileName) as NSString
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MZUtility.DownloadCompletedNotif as String), object: docDirectoryPath)
    }
    
    func downloadRequestDidFailedWithError(_ error: NSError, downloadModel: MZDownloadModel, index: Int) {
        self.refreshCellForIndex(downloadModel, index: index)
        
        debugPrint("Error while downloading file: \(String(describing: downloadModel.fileName))  Error: \(String(describing: error))")
    }
    
    func downloadRequestDestinationDoestNotExists(_ downloadModel: MZDownloadModel, index: Int, location: URL) {
        let myDownloadPath = MZUtility.baseFilePath + "/Default folder"
        if !FileManager.default.fileExists(atPath: myDownloadPath) {
            try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
        }
        let fileName = MZUtility.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(downloadModel.fileName as String) as NSString)
        let path =  myDownloadPath + "/" + (fileName as String)
        try! FileManager.default.moveItem(at: location, to: URL(fileURLWithPath: path))
        debugPrint("Default folder path: \(myDownloadPath)")
    }
    
    
    
}
// MARK:- UITableViewDataSource
extension MultiFileDownloadViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadManager.downloadingArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier : NSString = "FileDownloadCell"
        let cell : FileDownloadCell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as! FileDownloadCell
        cell.cancelButtonOutlet.addTarget(self, action:#selector(self.downloadCancelAction(_:)), for: .touchUpInside)
        cell.cancelButtonOutlet.tag=indexPath.row
        let downloadModel = downloadManager.downloadingArray[indexPath.row]
        cell.updateCellForRowAtIndexPath(indexPath, downloadModel: downloadModel)
        
        return cell
    }
    
    
    
}

