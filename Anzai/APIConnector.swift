//
//  APIConnector.swift
//  swiftavfcidetector2
//
//  Created by ryomigita with 松浦 雅人 on 2017/02/24.
//  Copyright © 2017年 Yoshihisa Nitta. All rights reserved.
//

import UIKit


class APIConnector : NSObject {
    
    var type:Int = 0 //シーン選択
    var object:Any //POSTするデータ
    
    var activity:UIViewController
    var indicator = UIActivityIndicatorView()
    var group = DispatchGroup()
    
    var resultState:Int = -1
    
    var eventArray:[EventData] = [EventData]()
    
    init(activity: UIViewController, type: Int, object: Any){
        //親アクティビティのインスタンス保持 => グルグル表示
        self.activity = activity
        self.type = type
        self.object = object
        
        super.init()
    }
    
    
    //実行する関数（APIへアクセス＆配列へ格納）
    func execute(){
        
        //type
        //      1 = getsEvent : イベント一覧を受信
        //      2 = setJoin  : イベントとメンバーのidをPOST
        //      3 = setEvent : イベントにまつわる要素をPOST
        //      4 = viewJoinList : 参加予定イベント

        
        
        //1回APIを叩く
        //        for i in 0..<countryArray.count {
        //            group.enter()
        //            DispatchQueue.global().async {
        //                self.getRateArray(num: i)
        //            }
        //        }
        
        
        //typeによってAPIを出し分け
        if(self.type==0){
            return
            
        }else if(self.type==1){
            //処理中のグルグルを表示
            showIndicator()
            //ディスパッチエントリー
            group.enter()
            //非同期通信
            DispatchQueue.global().async {
                self.getEvents()
            }
            //非同期処理完了
            group.notify(queue: .global()) {
                print("データ取得完了")
                DispatchQueue.main.async {

                    self.endIndicator()
                }
            }
            
        }else if(self.type==2){
            showIndicator()
            group.enter()
            //非同期通信
            DispatchQueue.global().async {
                self.setJoin() //実際にAPIを叩く処理
            }
            //非同期処理完了
            group.notify(queue: .global()) {
                print("データ取得完了")
                DispatchQueue.main.async {
                    
                    self.endIndicator()
                }
            }
        
        }else if(self.type==3){
            showIndicator()
            group.enter()
            //非同期通信
            DispatchQueue.global().async {
                self.setEvent() //実際にAPIを叩く処理
            }
            //非同期処理完了
            group.notify(queue: .global()) {
                print("データ取得完了")
                DispatchQueue.main.async {
                    
                    self.endIndicator()
                }
            }
        }else if(self.type==4){
            showIndicator()
            group.enter()
            //非同期通信
            DispatchQueue.global().async {
                self.getEvents() //実際にAPIを叩く処理
            }
            //非同期処理完了
            group.notify(queue: .global()) {
                print("データ取得完了")
                DispatchQueue.main.async {
                    
                    self.endIndicator()
                }
            }
        }

        
    }
    
    
    //イベント一覧を受信
    func getEvents(){
        
        let baseUrl:String = "http://anzai.nikita.jp/show_event_list.php"
        var request = URLRequest(url: URL(string:baseUrl)!)
        
        //typeごとに叩くURLを変える
        if(type==1){
            let joinData:String = self.object as! String
            
            // set the method(HTTP-POST)
            request.httpMethod = "POST"
            
            //送るデータ
            let query = "member_id=\(joinData)&" +
                        "type=\(type)"
            
            request.httpBody = query.data(using: String.Encoding.utf8)
            
        }else if(type==4){
            
            let joinData:String = self.object as! String
            
            // set the method(HTTP-POST)
            request.httpMethod = "POST"
            
            //送るデータ
            let query = "member_id=\(joinData)&" +
                        "type=\(type)"
            
            request.httpBody = query.data(using: String.Encoding.utf8)
            
        }
            
            
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            } else {
                
                do {

                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:String]]

                    print(parsedData)
                    
                    if(parsedData[0]["result"] == "1"){
                        //イベント一覧受信成功
                        self.resultState = 1
                        
                        for i in 1 ..< parsedData.count {
                            let tmp = parsedData[i]
                            let event = EventData()
                            event.setEventId(str: tmp["event_id"]!)
                            event.setName(str: tmp["name"]!)
                            event.setEventDate(str: tmp["event_date"]!)
                            event.setStartTime(str: tmp["start_time"]!)
                            event.setEndTime(str: tmp["end_time"]!)
                            event.setLocation(str: tmp["location"]!)
                            event.setMaxMemberNum(num: Int(tmp["max_menber_num"]!)!)
                            event.setComment(str: tmp["comment"]!)
                            let img: UIImage = UIImage(named: "No_images.jpg")!
                            event.setEventImg(obj: img)
                            //1:true, 0:false
                            if(tmp["join"]=="1"){
                                event.setJoinFlag(flag: true)
                            }else{
                                event.setJoinFlag(flag: false)
                            }
                            
                            self.eventArray.append(event)
                        }
  
                    }else{
                        //エラー
                        self.resultState = -1
                    }
                    
                    self.group.leave()
                } catch {
                    //エラー処理
                    self.resultState = -1
                    self.group.leave()
                }
            }
            
        })
        
        task.resume()
    }
    
    //イベントとメンバーのidをPOST
    func setJoin(){
        
        let baseUrl:String = "http://anzai.nikita.jp/regist_event_member.php"
        var request = URLRequest(url: URL(string:baseUrl)!)
        //POST:自身のmember_id, 参加したいevent_id
        
        let joinData:[String:String] = self.object as! [String:String]
        
        // set the method(HTTP-POST)
        request.httpMethod = "POST"
        //送るデータ
        let query = "member_id=\(joinData["myId"]!)&" +
                    "event_id=\(joinData["eventId"]!)"
        
        request.httpBody = query.data(using: String.Encoding.utf8)
        
        //通信を実施
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            } else {
                
                do {//結果が返って来た後の処理
                    //parsedDate : jsonのデータ→Arrayデータとみなす
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:String]
                    
                    print(parsedData)
                    
                    if(parsedData["result"] == "1"){
                        //イベント一覧受信成功
                        self.resultState = 1
                        
                        
                    }else if(parsedData["result"] == "2"){
                        //イベント一覧受信成功
                        self.resultState = 2
                        
                    }else{
                        //エラー
                        self.resultState = -1
                    }
                    
                    self.group.leave()
                } catch {
                    //エラー処理
                    self.resultState = -1
                    self.group.leave()
                }
            }
            
        })
        
        task.resume()
    }

    //イベントをPOST
    func setEvent(){
        
        let baseUrl:String = "http://anzai.nikita.jp/add_event.php"//変更済み
        var request = URLRequest(url: URL(string:baseUrl)!)
        //POST:自身のmember_id, 参加したいevent_id
        
        let eventData:EventData = self.object as! EventData
        //let joinData:[String:String] = self.object as! [String:String]
        
        // set the method(HTTP-POST)
        request.httpMethod = "POST"
        //送るデータ
        let query = "name=\(eventData.getName())&" +
                    "event_date=\(eventData.getEventDate())&" +
                    "start_time=\(eventData.getStartTime())&" +
                    "end_time=\(eventData.getEndTime())&" +
                    "location=\(eventData.getLocation())&" +
                    "max_member_num=\(eventData.getMaxMemberNum())&" +
                    "comment=\(eventData.getComment())&" +
                    "level=\(eventData.getLevel())"

        
        request.httpBody = query.data(using: String.Encoding.utf8)
        
        //通信を実施
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            } else {
                
                do {//結果が返って来た後の処理
                    //parsedDate : jsonのデータ→Arrayデータとみなす
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:String]
                    
                    print(parsedData)
                    
                    if(parsedData["result"] == "1"){
                        //イベント一覧受信成功
                        self.resultState = 1
                        
                        
                    }else{
                        //エラー
                        self.resultState = -1
                    }
                    
                    self.group.leave()
                } catch {
                    //エラー処理
                    self.resultState = -1
                    self.group.leave()
                }
            }
            
        })
        
        task.resume()
    }

    
    
    //グルグル生成＆表示
    func showIndicator() {
        
        // UIActivityIndicatorView のスタイルをテンプレートから選択
        indicator.activityIndicatorViewStyle = .whiteLarge
        // 表示位置
        indicator.center = activity.view.center
        // 色の設定
        indicator.color = UIColor.gray
        // アニメーション停止と同時に隠す設定
        indicator.hidesWhenStopped = true
        // 画面に追加
        activity.view.addSubview(indicator)
        // 最前面に移動
        activity.view.bringSubview(toFront: indicator)
        // アニメーション開始
        indicator.startAnimating()
        
    }

    
    //終了判定
    func endIndicator() {
        
        if(self.type==1){
            self.indicator.stopAnimating()
            
            if(self.resultState==1){
                //成功
//                let alert = UIAlertController(
//                    title: "成功",
//                    message: "会員登録が完了しました。",
//                    preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default))
//                activity.present(alert, animated: true, completion: nil)
                
                //★ここがEventListTableViewにのみ対応なので、scheduleListから飛ばしたときに処理ができない
                let vc = self.activity as! EventListViewController
                vc.recievedData(array: eventArray)
            
            
            }else{
                //失敗
                let alert = UIAlertController(
                    title: "通信エラー",
                    message: "再度お試しください。",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: nil)
            }
            
        }
        
        else if(self.type==2){
            self.indicator.stopAnimating()
            
            if(self.resultState==1){
                //成功
                let alert = UIAlertController(
                title: "成功",
                message: "イベントの参加登録が完了しました。",
                preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: nil)
                
                //成功をトリガーにアクションを起こす場合には下記に記載（別ページに飛ばすなど）
                //★呼び出し元の実権を使って、値渡し
                let statusJoin = self.activity as! detailEventViewController
                statusJoin.recievedData(result: 1)
                
                
            }else if(self.resultState==2){
                let alert = UIAlertController(
                    title: "成功",
                    message: "イベントをキャンセルしますか？",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "キャンセルする", style: .default))
                activity.present(alert, animated: true, completion: nil)
                
                
                
                //★呼び出し元の実権を使って、値渡し
                let statusJoin = self.activity as! detailEventViewController
                statusJoin.recievedData(result: 2)
                
            
            }else{
                //失敗
                let alert = UIAlertController(
                    title: "通信エラー",
                    message: "再度お試しください。",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: nil)
            }
            
        }
        else if(self.type==3){//setEvent
            self.indicator.stopAnimating()
            
            if(self.resultState==1){
                //成功
                let alert = UIAlertController(
                title: "成功",
                message: "練習の追加が完了しました。",
                preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: nil)
                
                
            }else{
                //失敗
                let alert = UIAlertController(
                    title: "通信エラー",
                    message: "再度お試しください。",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: nil)
            }
            
        }

        
        else if(self.type==4){
            self.indicator.stopAnimating()
            
            if(self.resultState==1){
                //成功
                //                let alert = UIAlertController(
                //                    title: "成功",
                //                    message: "会員登録が完了しました。",
                //                    preferredStyle: .alert)
                //                alert.addAction(UIAlertAction(title: "OK", style: .default))
                //                activity.present(alert, animated: true, completion: nil)
                
                let vc = self.activity as! ScheduleListViewController
                vc.recievedData(array: eventArray)
                
                
            }else{
                //失敗
                let alert = UIAlertController(
                    title: "通信エラー",
                    message: "再度お試しください。",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: nil)
            }
            
        }

    }
    
    
}
