//
//  ScheduleListViewController.swift
//  Anzai
//
//  Created by MIGGI on 2017/03/01.
//  Copyright © 2017年 Ryo Migita. All rights reserved.
//

import UIKit

class ScheduleListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scheduleTableview: UITableView!

    
    
    
    var eventArray:[EventData] = [EventData]()
    var selectData:EventData? = nil
    
    var myId:String = "55933034236817171279" //IDを仮置き
    
    
    override func viewWillAppear(_ animated: Bool) {//画面が出来上がる前の処理
        //テストデータ生成
//        var event = EventData()
//                event.setName(str: "Hongover練習")
//                event.setEventDate(str: "2/26")
//                event.setStartTime(str: "19")
//                event.setEndTime(str: "21時")
//                let img: UIImage = UIImage(named: "lena.jpg")!
//                event.setEventImg(obj: img )
//        
//                //仮置きしたeventを配列に追加
//                eventArray.append(event)
        
        
        let apiCon:APIConnector =
            APIConnector(activity: self, type: 4, object: myId)
        apiCon.execute()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.scheduleTableview.delegate = self
        self.scheduleTableview.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //--------------------------
    // TableView for EventData
    //--------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    //セルのセット
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        
        let cell: EventOverviewCell = tableView.dequeueReusableCell(withIdentifier: "EventOverviewCell", for: indexPath) as! EventOverviewCell
        cell.setCell(EventOverview: eventArray[indexPath.row], index:indexPath.row)
        
        return cell
    }
    
    //リスト選択イベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //一覧の中で選択したイベントのデータ
        selectData = eventArray[indexPath.row]
        
        performSegue(withIdentifier: "callDetailEventfromJoinView", sender: self)
        
        
    }
    
    
    //segueでイベント詳細へ画面遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "callDetailEventfromJoinView"{
            //callDetailEventViewをインスタンス化
            let cDEV = segue.destination as! detailEventViewController
            //値をdetailEventViewControllerに渡す
            cDEV.selectEventListData = selectData
        }
    }
    
    
    //secondViewControllerから戻るための設定
    @IBAction func returnToTopWithSegue(segue: UIStoryboardSegue) {}
    
    //イベント詳細へ画面遷移
    //        let storyboard: UIStoryboard = self.storyboard!
    //        let nextView = storyboard.instantiateViewController(withIdentifier: "detailEventView")
    //        let navi = UINavigationController(rootViewController: nextView)
    //        // アニメーションの設定 画面遷移のインスタンスメソッドpresent
    //        // navi.modalTransitionStyle = .coverVertical
    //        present(navi, animated: true, completion: nil)
    //
    //        //履歴読み込み
    //        dispStr = selectData.getDispStr()
    //        label_disp.text = dispStr
    //        numArray = selectData.getNumArray()
    //        temp = numArray[numArray.count-1]
    //        numArray.remove(at: numArray.count-1)
    //        opeArray = selectData.getOpeArray()
    //
    //        //最後尾の数値からモード判定
    //        decideMode()
    //
    //        //選択以降の履歴削除
    //        var max = eventArray.count
    //        for _ in indexPath.row ..< max {
    //            eventArray.remove(at: indexPath.row)
    //            max = eventArray.count
    //        }
    //        tv_history.reloadData()
    //        tv_history.setContentOffset(
    //            CGPoint(x:0, y:tv_history.contentSize.height - tv_history.frame.size.height),
    //            animated: true);
    //
    
    func recievedData(array: [EventData]) {//受信したデータのarray
        self.eventArray = array
        scheduleTableview.reloadData()
    }
}
