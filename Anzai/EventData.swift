//
//  EventData.swift
//  Anzai
//
//  Created by MIGGI on 2017/02/26.
//  Copyright © 2017年 Ryo Migita. All rights reserved.
//

import UIKit

//eventの情報を格納するオブジェクト生成するクラス
class EventData: NSObject {
    
    var event_id:String = ""
    var name:String = ""
    var event_date:String = ""
    var start_time:String = ""
    var end_time:String = ""
    var location:String = ""
    var max_member_num:Int = 0
    var comment:String = ""
    var level:Int = 0
    var eventImg:UIImage? = nil
    var joinFlag:Bool = false
    
    init(event_id:String, name:String, event_date:String, start_time:String, end_time:String, location:String, max_member_num:Int, comment:String, level:Int, eventImg:UIImage, joinFlag:Bool) {
        self.event_id = event_id
        self.name = name
        self.event_date = event_date
        self.start_time = start_time
        self.end_time = end_time
        self.location = location
        self.max_member_num = max_member_num
        self.comment = comment
        self.level = level
        self.eventImg = eventImg
        self.joinFlag = joinFlag
        
        super.init()
    }
    
    override init(){
        
    }
    
    
    //Setter（Server→Object生成）
    
    func setEventId(str:String){
        self.event_id = str
    }
    
    func setName(str:String){
        self.name = str
    }
    
    func setEventDate(str:String){
        self.event_date = str
    }
    
    func setStartTime(str:String){
        self.start_time = str
    }
    
    func setEndTime(str:String){
        self.end_time = str
    }
    
    func setLocation(str:String){
        self.location = str
    }
    
    func setMaxMemberNum(num:Int){
        self.max_member_num = num
    }
    
    func setComment(str:String){
        self.comment = str
    }
    func setLevel(num:Int){
        self.level = num
    }
    
    func setEventImg(obj:UIImage){
        self.eventImg = obj
    }
    
    func setJoinFlag(flag:Bool){
        self.joinFlag = flag
    }
    
    
    //Getter（生成したObject→クライアント側表示用）
    
    func getEventId() -> String {
        return self.event_id
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getEventDate() -> String {
        return self.event_date
    }
    
    func getStartTime() -> String {
        return self.start_time
    }
    
    func getEndTime() -> String {
        return self.end_time
    }
    
    func getLocation() -> String {
        return self.location
    }
    
    func getMaxMemberNum() -> Int {
        return self.max_member_num
    }
    
    func getComment() -> String {
        return self.comment
    }
    func getLevel() -> Int {
        return self.level
    }
    
    func getEventImg() -> UIImage {
        return self.eventImg!
    }
    func getJoinFlag() -> Bool {
        return self.joinFlag
    }
    
}
