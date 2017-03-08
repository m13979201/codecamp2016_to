//
//  detailEventViewController.swift
//  Anzai
//
//  Created by MIGGI on 2017/02/26.
//  Copyright © 2017年 Ryo Migita. All rights reserved.
//

import UIKit

class detailEventViewController: UIViewController {

    //ViewController.swiftから計算結果の値を受け取るための変数
    var selectEventListData:EventData? = nil

    
    @IBOutlet weak var eventimg: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    //イベント参加メンバリストを作る
    var postData:[String:String] = [String:String]()
    

    @IBOutlet weak var joinBtn: UIButton!
    
    @IBAction func contactBtn(_ sender: Any) {}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //イベントの参加判定を事前に確認
        
        if(selectEventListData?.getJoinFlag())!{//true
            joinBtn.setTitle("キャンセルする", for: .normal)
        }else{//false
            joinBtn.setTitle("参加する(￥200)", for: .normal)
        }
        
        
        //参加登録(@IBOutlet接続したボタンを押したときに特定のfuncを呼べるようにする処理)
        joinBtn.addTarget(self, action: #selector(self.pushJoinBtn(sender:)), for: .touchUpInside)
        
        
        //labelにデータを受け渡し
        eventNameLabel.text = selectEventListData?.getName()
        eventDateLabel.text = selectEventListData?.getEventDate()
        eventTimeLabel.text = (selectEventListData?.getStartTime())! + "〜" + (selectEventListData?.getEndTime())!
        eventLocationLabel.text = selectEventListData?.getLocation()
        
        
        //★ユーザーID仮置き　ログインページ載せ替え
        postData.updateValue("55933034236817171279", forKey: "myId")
        postData.updateValue((selectEventListData?.getEventId())!, forKey: "eventId")
        
    }
    
    func pushJoinBtn(sender: UIButton){
        let apiCon:APIConnector = APIConnector(activity: self, type: 2, object: postData)
        apiCon.execute()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func recievedData(result: Int) {//受信したデータのarray
        if(result==1){
            joinBtn.setTitle("キャンセルする", for: .normal)
        }else if(result==2){
            joinBtn.setTitle("参加する(￥200)", for: .normal)
        }else{
            print("receiveData error!")
        }
    }
    

}
