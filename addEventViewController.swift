//
//  addEventViewController.swift
//  Anzai
//
//  Created by MIGGI on 2017/03/05.
//  Copyright © 2017年 Ryo Migita. All rights reserved.
//

import UIKit

class addEventViewController: UIViewController {

    
    //サーバーへデータを送るためのデータ型のオブジェクト
    var addEventData:EventData? = nil

    @IBOutlet weak var eventNameTextFiled: UITextField!
    
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    @IBOutlet weak var locationTextFiled: UITextField!

    @IBOutlet weak var maxMemberNumTextField: UITextField!
    
    
    @IBAction func backBtn(_ sender: Any) {
    }
    
    
    @IBAction func addEventBtn(_ sender: Any) {
        //ここにAPIConnect呼び出す処理を書く
        addEventData = EventData()
        addEventData?.setName(str: eventNameTextFiled.text!)
//        addEventData?.setEventDate(str: eventDatePicker)
//        addEventData?.setStartTime(str: startTimePicker)
//        addEventData?.setEndTime(str: endTimePicker)
        addEventData?.setEventDate(str: "2020-01-01")
        addEventData?.setStartTime(str: "19:00:00")
        addEventData?.setEndTime(str: "21:00:00")
        addEventData?.setLocation(str: locationTextFiled.text!)
        addEventData?.setMaxMemberNum(num: Int(maxMemberNumTextField.text!)!)
        
        //APIの呼び出し
        let apiCon:APIConnector =
            APIConnector(activity: self, type: 3, object: addEventData!)
        apiCon.execute()
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    //キーボードが出ている状態で、キーボード以外をタップしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(eventNameTextFiled.isFirstResponder || locationTextFiled.isFirstResponder || maxMemberNumTextField.isFirstResponder){
            eventNameTextFiled.resignFirstResponder()
            locationTextFiled.resignFirstResponder()
            maxMemberNumTextField.resignFirstResponder()
        }
    }
    
//    func recievedData(array: [EventData]) {//受信したデータのarray
//        self.eventArray = array
//        eventTableview.reloadData()
//    }


}
