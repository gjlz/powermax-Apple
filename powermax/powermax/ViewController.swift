//
//  ViewController.swift
//  powermax
//
//  Created by newpower on 2019/11/27.
//  Copyright © 2019 newpower. All rights reserved.
//

import UIKit
import CoreBluetooth


class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var TBV: UITableView!
    var advs = [String]()
    
    lazy var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = {
        return Array<(peripheral: CBPeripheral, RSSI: Float)>()
    }()
    
    var BTdata:String?
//    tbv的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
//    tbv的显示样式
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "abc")!

        cell.textLabel?.text =  self.peripherals[indexPath.row].peripheral.name
        cell.detailTextLabel?.text = self.advs[indexPath.row]//String(peripherals[indexPath.row].RSSI)
        
//        cell.imageView?.image = UIImage(named: "help")
        return cell
    }
//    tbv选择事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        连接蓝牙
        serial.stopScan()
    serial.connectToPeripheral(self.peripherals[indexPath.row].peripheral)
//        print("选择了\(indexPath.row)")
//        let pa:powermaxViewC = storyboard!.instantiateViewController(withIdentifier: "PA") as! powermaxViewC
//        present(pa,animated: true)
//        self.performSegue(withIdentifier: "toPA", sender: nil)  //跳转界面

    }
//    cll的标题
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Pull To Search Device"
    }
/// 下拉刷新初始化
    func shaxin_init() {
//        1.建立刷新对象
        let shaxin = UIRefreshControl()
//        2.设置文字
        shaxin.attributedTitle = NSAttributedString(string: "Pull To Refresh")
//        3.创建刷新后事件
        shaxin.addTarget(self, action: #selector(san), for: .valueChanged)
//        4.把刷新给表格
        self.TBV.refreshControl = shaxin
    }
//    清除扫描到的设备
    func removeall() {
        serial.pers.removeAllObjects()
        self.advs.removeAll()
        self.peripherals.removeAll()

    }
//    下拉事件
    @objc func san(){
        removeall()
        self.TBV.reloadData()
        serial.startScan()
//        结束刷新
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
//          print("延时2秒钟")
            self.TBV.refreshControl?.endRefreshing()

        }
    }
//    对话框
    func duihunkuang(标题:String,内容:String,btn:String) {
           let alertVC: UIAlertController = UIAlertController(title: 标题, message: 内容, preferredStyle: .alert)
           let okAction: UIAlertAction = UIAlertAction(title: btn, style: .default, handler: nil)
           alertVC.addAction(okAction)
           self.present(alertVC, animated: true, completion: nil)
       }
//    提示框
    func tishikuang(标题:String) {
           let alertVC: UIAlertController = UIAlertController(title: 标题, message: nil, preferredStyle: .alert)
           self.present(alertVC, animated: true, completion: nil)
//        self.presentedViewController?.dismiss(animated: false, completion: nil) //消失提示框
       }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        shaxin_init()
        serial = BluetoothSerial(delegate: self)
        
        // Do any additional setup after loading the view.
    }
//    / IO口解码
   @objc func IOjeima(mess:String) {
        let IO = mess
        if IO.contains("OK+PIO?:0") {
            let senIO = IO.suffix(1)
            serial.sendMessageToDevice("AT+BEFC00\(senIO)")
            serial.sendMessageToDevice("AT+AFTC00\(senIO)")
//            print("IO解码\(senIO)")
        }
        
    }
//    按键状态数据解码
    func IOdata(mess:String) {
            let IO = mess
            if IO.contains("OK+PIO?:0") {
                let IOdata = IO.suffix(1)
                BTdata = String(IOdata)
            }
    }
}
//------------------------------蓝牙代理-----------------------------
// MARK - BluetoothSerialDelegate
extension ViewController: BluetoothSerialDelegate {

   
    func serialDidChangeState() {
        if serial.centralManager.state != .poweredOn {
            duihunkuang(标题: "Bluetooth not on",内容: "Bluetooth is not turned on ,Please turn on Bluetooth.",btn:"OK")
        } else {
//            self.navigationItem.title = "正在掃描"
            removeall()
            serial.startScan()
        }
    }
///    发现设备
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
//            if self.peripherals.contains(where: { (peripheral: CBPeripheral, RSSI: Float) -> Bool in
//                return true    //开启这句就只能显示一个蓝牙设备
//            }) {
//                return
//            }
//            print("kCBAdvDataManufacturerData")
            self.peripherals.append((peripheral, RSSI as! Float))

            self.TBV.reloadData()
        }
    
//        正在连接
    func serialDidConnect(_ peripheral: CBPeripheral) {
//        self.peripherals.removeAll()
//        self.TBV.reloadData()
        
//        let pa:powermaxViewC = storyboard!.instantiateViewController(withIdentifier: "PA") as! powermaxViewC
//        pa.passdata = 数据
//        present(pa,animated: true) // 以对话框口跳转另一个界面
        tishikuang(标题: "Connecting...")
    }
    
//   已连接准备好通讯
    func serialIsReady(_ peripheral: CBPeripheral) {
        serial.sendMessageToDevice("AT+PIO??")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
//          print("延时1秒钟")
            self.performSegue(withIdentifier: "toPA", sender: nil)  //以Segue(连线方式)打开另一界面
            self.presentedViewController?.dismiss(animated: false, completion: nil) //关闭提示框
        }
    }
//   用连线方式传值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPA" {
            let pa = segue.destination as! powermaxViewC  //先拿到另一个控制器
            pa.passdata = BTdata  //给控制器的属性付值
        }
    }
//    断开时调用
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        print("已断开")
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true) //关闭界面
        tishikuang(标题: "Disconnected")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.presentedViewController?.dismiss(animated: true, completion: nil)
        }

    }
/// 收到信息,字符串
    func serialDidReceiveString(_ message: String) {
//        let me = message.contains("OK+PIO?")  //返回一个布尔值，指示序列是否包含给定元素。

        IOjeima(mess: message)
        IOdata(mess: message)
        print(message)
    }
//    获取广播数据
     func guangbo(advData: [String : Any]) {
        let macdata = advData["kCBAdvDataManufacturerData"]!
        let mac1 = String(describing: macdata)
        let mac2 = mac1.suffix(13)
        let NSmac = mac2 as NSString
        let mac1_2 = NSmac.substring(with: NSMakeRange(0, 2))
        let mac3_4 = NSmac.substring(with: NSMakeRange(2, 2))
        let mac5_6 = NSmac.substring(with: NSMakeRange(4, 2))
        let mac7_8 = NSmac.substring(with: NSMakeRange(6, 2))
        let mac9_10 = NSmac.substring(with: NSMakeRange(8, 2))
        let mac11_12 = NSmac.substring(with: NSMakeRange(10, 2))
        let mac = mac1_2 + ":" + mac3_4 + ":" + mac5_6 + ":" + mac7_8 + ":" + mac9_10 + ":" + mac11_12
//        print(mac)
        self.advs.append(mac)
//        print("发现设备时mac为\(String(describing: mac))")
        
    }
}
