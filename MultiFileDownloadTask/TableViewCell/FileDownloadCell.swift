//
//  FileDownloadCell.swift
//  MultiFileDownloadTask
//
//  Created by Subburaman, Rajai Kumar on 13/08/19.
//  Copyright © 2019 Subburaman, Rajai Kumar. All rights reserved.
//

import UIKit
import MZDownloadManager


class FileDownloadCell: UITableViewCell {
    @IBOutlet weak var fileNameLabel: UILabel!
    
    @IBOutlet weak var progressPercentageLabel: UILabel!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var progressValue: UIProgressView!
    
    @IBOutlet weak var downloadStatusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        // Configure the view for the selected state
    }
    
 
    
    func updateCellForRowAtIndexPath(_ indexPath : IndexPath, downloadModel: MZDownloadModel) {
        
        self.fileNameLabel?.text = "File Name: \(downloadModel.fileName!)"
        self.progressValue?.progress = downloadModel.progress
        var fileSize = "..."
        if let _ = downloadModel.file?.size {
            fileSize = String(format: "%.2f %@", (downloadModel.file?.size)!, (downloadModel.file?.unit)!)
        }
    self.fileSizeLabel?.text=fileSize
        if downloadModel.status == "Downloading"{
            
            self.downloadStatusLabel?.text="Status:"
        }else{
            self.downloadStatusLabel?.text="Status:"}
        
       self.progressPercentageLabel?.text=String(format: "%.0f%%", downloadModel.progress * 100.0) + " Completed"
    }
}
