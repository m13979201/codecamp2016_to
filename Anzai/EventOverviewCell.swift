//
//  EventOverviewCell.swift
//  Anzai
//
//  Created by MIGGI on 2017/02/26.
//  Copyright © 2017年 Ryo Migita. All rights reserved.
//


import UIKit

class EventOverviewCell: UITableViewCell {
    
    @IBOutlet weak var eventNameLabel: UITextField!
    @IBOutlet weak var eventDateLabel: UITextField!
    @IBOutlet weak var eventTimeLabel: UITextField!
    @IBOutlet weak var eventImgeView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //生成されるときに呼び出される
    func setCell(EventOverview :EventData, index :Int) {
        //EventData　gettrtの呼び出し
        self.eventNameLabel.text = EventOverview.getName()
        self.eventDateLabel.text = EventOverview.getEventDate()
        self.eventTimeLabel.text = EventOverview.getStartTime() + "〜" + EventOverview.getEndTime()
        self.eventImgeView.image = EventOverview.eventImg //仮置き
        
        
        //背景色設定
//        if(index%2==0){
//            self.backgroundColor = UIColor(hexString: "#F5F5F5")
//        }else{
//            self.backgroundColor = UIColor(hexString: "#F5FFFA")
//        }
        
        //レイアウト設定
//        self.label_equation.translatesAutoresizingMaskIntoConstraints = true
//        self.label_equation.frame = CGRect(x:10, y:5, width:Int(DeviceSize.screenWidth())-20, height:Int(self.frame.size.height)-10)
    }
    
}
