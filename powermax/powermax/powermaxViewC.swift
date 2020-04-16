//
//  File.swift
//  BLE Remote
//
//  Created by wushinien on 2018/9/15.
//  Copyright © 2018年 JtypeSu. All rights reserved.
//

import UIKit
import CoreBluetooth

class powermaxViewC: UIViewController {
    
    var timer: Timer!
    var passdata : String?
    
//    @IBOutlet weak var 显示: UILabel!

    @IBOutlet weak var out1: UISwitch!
    @IBOutlet weak var out2: UISwitch!
    @IBOutlet weak var out3: UISwitch!
    @IBOutlet weak var out4: UISwitch!
    
    override var shouldAutorotate: Bool {
        get {
            return true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get  {
            return UIInterfaceOrientationMask.portrait
        }
    }

    override var prefersStatusBarHidden: Bool {
        get {
            return false
        }
    }
    
//    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         serial.delegate = self
//            print("传过来的\(passdata!)")
        if let passdata = passdata {
            BTzhuangtai(mess: passdata)

        }
    }
    
//    @IBAction func clickBack(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//        serial.disconnect()
//        self.navigationController?.popViewController(animated: true)  //用navigationController关闭界面
//    }
    
// 按钮按下事件
    @IBAction func down(_ sender: UIButton) {
        switch (sender.tag) {
        case 10:    //M1正转
            serial.sendMessageToDevice("AT+PIO61")
            serial.sendMessageToDevice("AT+PIO61")
            break;
            
        case 20:    //M1反转
            serial.sendMessageToDevice("AT+PIO71")
            serial.sendMessageToDevice("AT+PIO71")
            break;
            
        case 30:    //M2
            serial.sendMessageToDevice("AT+PIO41")
            serial.sendMessageToDevice("AT+PIO41")
            break;
            
        case 40:    //M2
            serial.sendMessageToDevice("AT+PIO51")
            serial.sendMessageToDevice("AT+PIO51")
            break;
            
        case 50:    //M3
            serial.sendMessageToDevice("AT+PIO21")
            serial.sendMessageToDevice("AT+PIO21")
            break;
            
        case 60:    //M3
            serial.sendMessageToDevice("AT+PIO31")
            serial.sendMessageToDevice("AT+PIO31")
            break;
            
        default:
            break
            
        }
    }
    
// 按钮松开事件
    @IBAction func up(_ sender: UIButton) {
        switch (sender.tag) {
        case 10:    //M1正转
            serial.sendMessageToDevice("AT+PIO60")
            serial.sendMessageToDevice("AT+PIO60")
            break;
            
        case 20:    //M1反转
            serial.sendMessageToDevice("AT+PIO70")
            serial.sendMessageToDevice("AT+PIO70")
            break;
            
        case 30:    //M2
            serial.sendMessageToDevice("AT+PIO40")
            serial.sendMessageToDevice("AT+PIO40")
            break;
            
        case 40:    //M2
            serial.sendMessageToDevice("AT+PIO50")
            serial.sendMessageToDevice("AT+PIO50")
            break;
            
        case 50:    //M3
            serial.sendMessageToDevice("AT+PIO20")
            serial.sendMessageToDevice("AT+PIO20")
            break;
            
        case 60:    //M3
            serial.sendMessageToDevice("AT+PIO30")
            serial.sendMessageToDevice("AT+PIO30")
            break;
            
        default:
            break
            
        }
    }
    
//    @IBAction func test(_ sender: Any) {
//        serial.sendMessageToDevice("AT+PIO??")
//    }

    @IBAction func out1(_ sender: UISwitch) {
        
        if sender.isOn == true{
            serial.sendMessageToDevice("AT+PIOB1")
        }
        else{serial.sendMessageToDevice("AT+PIOB0")
        }
        serial.sendMessageToDevice("AT+PIO??")

    }

    @IBAction func out2(_ sender: UISwitch) {
        
        if sender.isOn == true{
            serial.sendMessageToDevice("AT+PIOA1")
        }
        else{serial.sendMessageToDevice("AT+PIOA0")
        }
        serial.sendMessageToDevice("AT+PIO??")

    }

    @IBAction func out3(_ sender: UISwitch) {
        
        if sender.isOn == true{
            serial.sendMessageToDevice("AT+PIO91")
        }
        else{serial.sendMessageToDevice("AT+PIO90")
        }
        serial.sendMessageToDevice("AT+PIO??")

    }

    @IBAction func out4(_ sender: UISwitch) {
        
        if sender.isOn == true{
            serial.sendMessageToDevice("AT+PIO81")
        }
        else{serial.sendMessageToDevice("AT+PIO80")
        }
        serial.sendMessageToDevice("AT+PIO??")

    }
    
    //当视图完全转换到屏幕上时调用。违约不起作用
//    override func viewDidAppear(_ animated: Bool) {
//            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timediscon), userInfo: nil, repeats: true)
//    }
//    /当视图被解除、覆盖或隐藏时调用。违约不起作用
//    override func viewWillDisappear(_ animated: Bool) {
//        serial.disconnect()
//    }
    override func viewDidDisappear(_ animated: Bool) {
        serial.disconnect()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
//   十六进制字符串转整型
    func hexStringToInt(from:String) -> Int {
        let str = from.uppercased()
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
//    a和b相与如果等圩a就反回真
    func AandB(a:Int,b:Int) -> Bool {
        let oc = a & b
        if oc == a {
           return true
        }else {return false}
    }
//    按键的状态解码
    func BTzhuangtai(mess:String) {
//            let IO = mess
//        let IO1 = IO.suffix(1)
        let IOzt = hexStringToInt(from: mess)
            if AandB(a: 1, b: IOzt) {
                out1.setOn(true, animated: true)
            }
            if AandB(a: 2, b: IOzt) {
                out2.setOn(true, animated: true)
            }
            if AandB(a: 4, b: IOzt) {
                out3.setOn(true, animated: true)
            }
            if AandB(a: 8, b: IOzt) {
                out4.setOn(true, animated: true)
            }
 
    }
}

// MARK - BluetoothSerialDelegate
/*
 extension powermaxViewC: BluetoothSerialDelegate {
/// 蓝牙状态
    func serialDidChangeState() {
        if serial.centralManager.state != .poweredOn {
            serial.disconnect()
        }
    }
/// 收到信息,字符串
    func serialDidReceiveString(_ message: String) {
        let me = message.contains("OK+PIO?")  //返回一个布尔值，指示序列是否包含给定元素。
        if me {
            print(message)
            out1.setOn(true, animated: true)
        }
        
//        let 消息 = message.hasPrefix("OK+PIO2") //返回一个布尔值，指示字符串是否以指定的前缀开头。
//        if 消息 {
//            print("有AT+PIO2")
//        }
        显示.text? = message
        print("\(message)")
    }
    
   @objc func serialDidReadRSSI(_ rssi: NSNumber) {
        显示.text? = "\(rssi)"
    }
/// 连接失败
   @objc func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        
//            let alertVC: UIAlertController = UIAlertController(title: "錯誤", message: "連線中斷", preferredStyle: .alert)
//            let okAction: UIAlertAction = UIAlertAction(title: "好", style: .default, handler: nil)
//            alertVC.addAction(okAction)
//            self.present(alertVC, animated: true, completion: nil)
    }

//    override func viewDidDisappear(_ animated: Bool) {
//        // 將timer的執行緒停止
//        if self.timer != nil {
//            self.timer?.invalidate()
//        }
//    }
//    @objc func timediscon(){
//
//        if CBPeripheralState.connected == .connected{
//            let alertVC: UIAlertController = UIAlertController(title: "成功", message: "已連線", preferredStyle: .alert)
//            let okAction: UIAlertAction = UIAlertAction(title: "好", style: .default, handler: nil)
//            alertVC.addAction(okAction)
//            self.present(alertVC, animated: true, completion: nil)
//            
//        }
//        else{
//            let alertVC1: UIAlertController = UIAlertController(title: "錯誤", message: "連線中斷", preferredStyle: .alert)
//            let okAction: UIAlertAction = UIAlertAction(title: "好", style: .default, handler: nil)
//            alertVC1.addAction(okAction)
//            self.present(alertVC1, animated: true, completion: nil)
//        }
//    }
    
     }  **/

