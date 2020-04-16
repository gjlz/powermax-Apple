//
//  BluetoothSerial.swift
//  BLE Remote
//
//  Created by wushinien on 2018/9/15.
//  Copyright © 2018年 JtypeSu. All rights reserved.
//

import UIKit
import CoreBluetooth

/// Global serial handler, don't forget to initialize it with init(delgate:)全局串行处理程序，不要忘记用init初始化它（delgate:）
var serial: BluetoothSerial!

// Delegate functions //委托函数
protocol BluetoothSerialDelegate {
    // ** Required **  //**必需的**
    
    /// Called when de state of the CBCentralManager changes (e.g. when bluetooth is turned on/off)
    ///当CBCentralManager的de状态更改时调用（例如，当蓝牙打开/关闭时）
    func serialDidChangeState()
    
    /// Called when a peripheral disconnected  //当外设断开连接时调用
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?)
    
    // ** Optionals **  可选的
    
    /// Called when a message is received  //收到消息时调用-字符串
    func serialDidReceiveString(_ message: String)
    
    /// Called when a message is received   ///收到消息时调用-字节
    func serialDidReceiveBytes(_ bytes: [UInt8])
    
    /// Called when a message is received  ///收到消息时调用-数据
    func serialDidReceiveData(_ data: Data)
    
    /// Called when the RSSI of the connected peripheral is read ///当读取所连接外设的RSSI时调用
    func serialDidReadRSSI(_ rssi: NSNumber)
    
    /// Called when a new peripheral is discovered while scanning. Also gives the RSSI (signal strength)
    ///  扫描时发现新外设时调用也给出RSSI（信号强度）
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?)
    
    /// Called when a peripheral is connected (but not yet ready for cummunication)
    ///  连接外设时调用（但尚未准备好进行通信）
    func serialDidConnect(_ peripheral: CBPeripheral)
    
    /// Called when a pending connection failed  //挂起连接失败时调用
    func serialDidFailToConnect(_ peripheral: CBPeripheral, error: NSError?)
    
    /// Called when a peripheral is ready for communication ///当外设准备好通信时调用
    func serialIsReady(_ peripheral: CBPeripheral)
    /// 发现设备时获取广播数据
    func guangbo(advData:[String : Any])
}

// Make some of the delegate functions optional // 使一些委托函数成为可选的
extension BluetoothSerialDelegate {
    func serialDidReceiveString(_ message: String) {}
    func serialDidReceiveBytes(_ bytes: [UInt8]) {}
    func serialDidReceiveData(_ data: Data) {}
    func serialDidReadRSSI(_ rssi: NSNumber) {}
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {}
    func serialDidConnect(_ peripheral: CBPeripheral) {}
    func serialDidFailToConnect(_ peripheral: CBPeripheral, error: NSError?) {}
    func serialIsReady(_ peripheral: CBPeripheral) {}
    func guangbo(advData:[String : Any]){}
}


final class BluetoothSerial: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    //MARK: Variables  //标记：变量
    
    /// The delegate object the BluetoothDelegate methods will be called upon
    ///  将调用BluetoothDelegate方法的delegate对象
    var delegate: BluetoothSerialDelegate!
    
    /// The CBCentralManager this bluetooth serial handler uses for... well, everything really
    //  此蓝牙串行处理程序用于。。。，一切都是真的
    var centralManager: CBCentralManager!
    
    /// The peripheral we're trying to connect to (nil if none)
    ///  我们要连接的外围设备（如果没有，则为零）
    var pendingPeripheral: CBPeripheral?
    
    /// The connected peripheral (nil if none is connected)
    ///  连接的外围设备（如果没有连接，则为零）
    var connectedPeripheral: CBPeripheral?
    
    /// The characteristic 0xFFE1 we need to write to, of the connectedPeripheral
    ///   我们需要写入的连接外设的特征0xFFE1
    weak var writeCharacteristic: CBCharacteristic?
    
    /// Whether this serial is ready to send and receive data
    ///  此序列号是否准备好发送和接收数据
    var isReady: Bool {
        get {
            return centralManager.state == .poweredOn &&
                connectedPeripheral != nil &&
                writeCharacteristic != nil
        }
    }
    
    /// Whether to write to the HM10 with or without response.
    /// Legit HM10 modules (from JNHuaMao) require 'Write without Response',
    /// while fake modules (e.g. from Bolutek) require 'Write with Response'.
    /// 是否向HM10写入有或无响应。
    /// 合法的HM10模块（来自JNHuaMao）需要“无响应写入”，
    /// 而假模块（例如来自Bolutek）需要“Write with Response”。
    var writeType: CBCharacteristicWriteType = .withoutResponse
    var pers = NSMutableArray()

    
    //MARK: functions  //标记：函数
    
    /// Always use this to initialize an instance ///始终使用此项初始化实例
    init(delegate: BluetoothSerialDelegate) {
        super.init()
        self.delegate = delegate
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    /// Start scanning for peripherals  ///开始扫描外围设备
    func startScan() {
        guard centralManager.state == .poweredOn else { return }
        
        // start scanning for peripherals with correct service UUID //开始扫描具有正确服务UUID的外围设备
        let uuid = CBUUID(string: "FFE0")
        centralManager.scanForPeripherals(withServices: [uuid], options: nil)
        
        // retrieve peripherals that are already connected //检索已连接的外围设备
        // see this stackoverflow question http://stackoverflow.com/questions/13286487
        //  请参阅此stackoverflow问题 http://stackoverflow.com/questions/13286487
//        返回连接到其服务符合给定条件集的系统的外围设备的列表。
//        let peripherals = centralManager.retrieveConnectedPeripherals(withServices: [uuid])
//        print(peripherals)
//        for peripheral in peripherals {
//            delegate.serialDidDiscoverPeripheral(peripheral, RSSI: nil)
//        }
    }
    
    /// Stop scanning for peripherals  ///停止扫描外设
    func stopScan() {
        centralManager.stopScan()
    }
    
    /// Try to connect to the given peripheral  ///尝试连接到给定的外设
    func connectToPeripheral(_ peripheral: CBPeripheral) {
        pendingPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }
    
    /// Disconnect from the connected peripheral or stop connecting to it ///断开连接的外围设备或停止连接
    func disconnect() {
        if let p = connectedPeripheral {
            centralManager.cancelPeripheralConnection(p)
        } else if let p = pendingPeripheral {
            centralManager.cancelPeripheralConnection(p) //TODO: Test whether its neccesary to set p to nil
        }
    }
    
    /// The didReadRSSI delegate function will be called after calling this function
    ///  调用此函数后将调用didrearssi委托函数
    func readRSSI() {
        guard isReady else { return }
        connectedPeripheral!.readRSSI()
    }
    
    /// Send a string to the device  //向设备发送字符串
    func sendMessageToDevice(_ message: String) {
        guard isReady else { return }
        
        if let data = message.data(using: String.Encoding.utf8) {
            connectedPeripheral!.writeValue(data, for: writeCharacteristic!, type: writeType)
        }
    }
    
    /// Send an array of bytes to the device /// 向设备发送字节数组
    func sendBytesToDevice(_ bytes: [UInt8]) {
        guard isReady else { return }
        
        let data = Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
        connectedPeripheral!.writeValue(data, for: writeCharacteristic!, type: writeType)
    }
    
    /// Send data to the device  /// 向设备发送数据
    func sendDataToDevice(_ data: Data) {
        guard isReady else { return }
        
        connectedPeripheral!.writeValue(data, for: writeCharacteristic!, type: writeType)
    }
    
    
    //MARK: CBCentralManagerDelegate functions /标记：CBCentralManagerDelegate 中心设备代理函数
//  扫描时发现新外设时调用
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // just send it to the delegate  //把它寄给代理
//     得出来的peripheral是这样的 <CBPeripheral: 0x280611400, identifier = 682427B5-F4FC-4543-AA16-F51736596DF9, name = NewPower-PA1, state = disconnected>
        print("调用到扫描")
        if (!pers.contains(peripheral))  {
            pers.add(peripheral)
            delegate.serialDidDiscoverPeripheral(peripheral, RSSI: RSSI)
            delegate.guangbo(advData: advertisementData)
        }

    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // set some stuff right  //把东西摆正
        peripheral.delegate = self
        pendingPeripheral = nil
        connectedPeripheral = peripheral
        
        // send it to the delegate  //发送给代理
        delegate.serialDidConnect(peripheral)
        
        // Okay, the peripheral is connected but we're not ready yet!
        // First get the 0xFFE0 service
        // Then get the 0xFFE1 characteristic of this service
        // Subscribe to it & create a weak reference to it (for writing later on),
        // and then we're ready for communication
        //好的，外围设备已经连接，但我们还没有准备好！
        //首先获取0xFFE0服务
        //然后获取此服务的0xFFE1特性
        //订阅它并创建对它的弱引用（供以后编写时使用），
        //然后我们就可以开始交流了
        peripheral.discoverServices([CBUUID(string: "FFE0")])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectedPeripheral = nil
        pendingPeripheral = nil
        
        // send it to the delegate  //发送给代理
        delegate.serialDidDisconnect(peripheral, error: error as NSError?)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        pendingPeripheral = nil
        
        // just send it to the delegate
        delegate.serialDidFailToConnect(peripheral, error: error as NSError?)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // note that "didDisconnectPeripheral" won't be called if BLE is turned off while connected
        // 请注意，如果在连接时关闭了BLE，则不会调用“didconnectperipheral”
        connectedPeripheral = nil
        pendingPeripheral = nil
        
        // send it to the delegate
        delegate.serialDidChangeState()
    }
    
    
    //MARK: CBPeripheralDelegate functions  外设代理函数
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        // discover the 0xFFE1 characteristic for all services (though there should only be one)
        //  发现所有服务的0xFFE1特征（尽管应该只有一个）
        for service in peripheral.services! {
            peripheral.discoverCharacteristics([CBUUID(string: "FFE1")], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // check whether the characteristic we're looking for (0xFFE1) is present - just to be sure
        // 检查我们要查找的特征（0xFFE1）是否存在-只是确定
        for characteristic in service.characteristics! {
            if characteristic.uuid == CBUUID(string: "FFE1") {
                // subscribe to this value (so we'll get notified when there is serial data for us..)
                // 订阅这个值（这样当有串行数据给我们时我们会得到通知…）
                peripheral.setNotifyValue(true, for: characteristic)
                
                // keep a reference to this characteristic so we can write to it
                // 保留对这个特性的引用，以便我们可以给它写信
                writeCharacteristic = characteristic
                
                // notify the delegate we're ready for communication //通知代表我们准备好沟通了
                delegate.serialIsReady(peripheral)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // notify the delegate in different ways
        // if you don't use one of these, just comment it (for optimum efficiency :])
        // 以不同的方式通知代表
        // 如果你不使用其中一个，只需屏蔽它（为了获得最佳效率：）
        let data = characteristic.value
//        guard data != nil else { return }
        
        // first the data //首先是数据
//        delegate.serialDidReceiveData(data!)
        
        // then the string 然后是字符串
        if let str = String(data: data!, encoding: String.Encoding.utf8) {
            delegate.serialDidReceiveString(str)
        } else {
            //print("Received an invalid string!") uncomment for debugging
        }
        
        // now the bytes array //现在是字节数组
//        var bytes = [UInt8](repeating: 0, count: data!.count / MemoryLayout<UInt8>.size)
//        (data! as NSData).getBytes(&bytes, length: data!.count)
//        delegate.serialDidReceiveBytes(bytes)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        delegate.serialDidReadRSSI(RSSI)
    }
}

