//
//  TimeViewController.swift
//  tomato
//
//  Created by cm0532_macAir on 2020/1/10.
//  Copyright © 2020 cm0532_macAir. All rights reserved.
//

import UIKit
import KDCircularProgress
import CoreNFC
import AVFoundation
import AudioToolbox

class TimeViewController: UIViewController, NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                if let string = String(data: record.payload, encoding: .ascii) {
                    print(string)
                }
            }
        }
//        session.invalidate()
    }
    
    var progress: KDCircularProgress!
    var delegate: TimerViewControllerDelegate?
    var nfcSession: NFCNDEFReaderSession?
    var myPlayer :AVAudioPlayer!
    var alarmIsOn : Bool = false
    var delayCount : Int = 0
//    @IBOutlet var progress: KDCircularProgress!
    @IBOutlet var btnPause: UIButton!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var btnstopAlarm: UIButton!
    @IBOutlet var btnStop: UIButton!
    
    @IBOutlet var btnTomato1: UIButton!
    @IBOutlet var btnTomato2: UIButton!
    
    @IBOutlet var btnTomato3: UIButton!
    @IBOutlet var btnTomato4: UIButton!
    @IBOutlet var btnTomato5: UIButton!
    @IBOutlet var btnTomato6: UIButton!
    @IBOutlet var btnTomato7: UIButton!
    @IBOutlet var btnTomato8: UIButton!
    @IBOutlet var btnDelay: UIButton!
    @IBOutlet var lbActivity: UILabel!
//    var cellData : (String, Int , UIImage)? = nil
    //傳過來的start
    var tomato = Tomato ()
    var arrayIndex : Int? = 0
    //傳過來的end
    var tomatoNum : Int = 0
    lazy var restNum :Int = tomatoNum - 1
    var resumeTapped = true
    var restMode = false
    var seconds = sTomatoTime //一輪的秒數是setting的番茄時間
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    var activityCount : Int = 0
    var player: AVPlayer!
    
     // MARK: - Controller Methods

     override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = true
        changeText(tomato.name)
        timerLabel.text = timeString(time: TimeInterval(sTomatoTime))
        seconds = sTomatoTime
        setProgress()
        activityCount += 1
        nfcInit()
        btnDelay.isHidden = true
        hideNavigation()
        btnstopAlarm.isHidden = true
        if tomato.tomatoNum != 8{
            for n in tomato.tomatoNum+1...8{
               let foundView = view.viewWithTag(n)
                foundView?.isHidden = true
            }
        }
    }
 
    func playAudio(){
        let url = Bundle.main.url(forResource: "ring", withExtension: "mp3")!
        player = AVPlayer(url: url)
        player?.actionAtItemEnd = .none

        NotificationCenter.default.addObserver(self,
           selector: #selector(playerItemDidReachEnd(notification:)),
           name: .AVPlayerItemDidPlayToEndTime,
           object: player?.currentItem)

        player?.play()
    }

    func stopAudio(){
        player?.pause()
    }
    @IBAction func stopAudio(_ sender: UIButton) {
        stopAudio()
    }
    func nfcInit(){
        /// invalidateAfterFirstRead 屬性表示是否需要識別多個NFC標籤，如果是true，則會話會在第一次識別成功後終止;
        /// 不過有一種例外情況，就是如果響應了協議中失敗的方法，不管是true還是false，會話都會被終止
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        
    }

    func setProgress(){ //  歸零
        progress = KDCircularProgress(frame: CGRect(x:38 , y: 150, width: 300, height: 300))
           progress.startAngle = -90
           progress.progressThickness = 0.25
           progress.trackThickness = 0.5
           progress.clockwise = true
           progress.gradientRotateSpeed = 2
           progress.roundedCorners = true
           progress.glowMode = .noGlow
           progress.glowAmount = 0
          progress.trackColor = UIColor(named:
        "tomato_green")!
           progress.set(colors: UIColor(named:
           "tomato_darkBlue")!)
//        progress.center = CGPoint(x: view.center.x , y: view.center.y, constant : 65 )
           view.addSubview(progress)
    }

    @objc func updateTimer() {
        if seconds < 1 {
            if !restMode{
                timer.invalidate()
                
                goRestAlarm()
                btnstopAlarm.isHidden = false
//                restMode = true
            }else{
                timer.invalidate()
                goActivityAlarm()
//                restMode = false
            }
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
        func runCircularProgress(){
    //        progress.progress = 0
    //        setProgress()
    //        progress.startAngle = -90
            progress.animate(toAngle: 360, duration: TimeInterval(seconds)) { completed in
                if completed {
//                    print("animation stopped, completed")
                } else {
//                    print("animation stopped, was interrupted")
                }
            }
        }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(TimeViewController.updateTimer)), userInfo: nil, repeats: true)
     }
    func runRest(){
        restMode = true
        changeText("休息")
        seconds = sRestTime
        setProgress()
        runCircularProgress()
        runTimer()
        print("!!!")
    }
    
    func runActivity(){
        restMode = false
        activityCount += 1
        seconds = sTomatoTime
        setProgress()
        runCircularProgress()
        runTimer()
        changeText(tomato.name)
    }
    
    func changeText(_ labelText : String){
          lbActivity.text = labelText
      }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
         if self.resumeTapped == false {
              timer.invalidate()
              progress.pauseAnimation()
              btnPause.setImage (UIImage (named: "timer_play"), for: .normal)
              self.resumeTapped = true
         } else {
              runTimer()
              runCircularProgress()
//              runActivity()
              btnPause.setImage (UIImage (named: "timer_pause"), for: .normal)
              self.resumeTapped = false
         }
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        alert("放棄確認" , "你確定要放棄此任務？")
        timer.invalidate()
        progress.pauseAnimation()
    }
    
  @IBAction func addOneMoreTomato(_ sender: UIButton) {
    btnDelay.isHidden = true
    delayCount = delayCount + 1
    stopAudio()
    alarmIsOn = false
    btnstopAlarm.isHidden = true
    btnStop.isHidden = false
    btnPause.isHidden = false
    let number = tomato.tomatoNum
    tomato.tomatoNum = number + 1
    print ("tomatoNum:\(tomato.tomatoNum)")
    print("restTime:\(sRestTime)")
    timerLabel.text = timeString(time: TimeInterval(sRestTime))
    runRest()
    
    }

    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    var timer2: Timer?
    var numberRepeat = 0
    var maxNumberRepeat = 20

    func startTimer() {
        //
        vibrateDevice()
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerHandler), userInfo: nil, repeats: true)
    }

    func stopTimer() {
        timer2?.invalidate()
        timer2 = nil
    }

    @objc func timerHandler() {
        if alarmIsOn{
            numberRepeat += 1
            vibrateDevice()
        } else {
            stopTimer()
        }
    }

    func vibrateDevice() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
     func goRestAlarm(){
        alarmIsOn = true
        if sIsRinging{
            playAudio()
        }
        if sIsVibrating{
            startTimer()
            
        }
         
        for n in 1...activityCount{
            let foundView = view.viewWithTag(n)
            foundView?.tintColor = UIColor(named:"brown")
        }
        
         if activityCount == tomato.tomatoNum {
             btnDelay.isHidden = false
         }
             btnPause.isHidden = true
             btnStop.isHidden = true
    }
    
   func goActivityAlarm(){
        alarmIsOn = true
        if sIsRinging{
            playAudio()
        }
        if sIsVibrating{
            startTimer()
        }
        btnstopAlarm.isHidden = false
        btnPause.isHidden = true
        btnStop.isHidden = true
    }
    
    @IBAction func closeAlarm(_ sender: UIButton) {
        stopAudio()
        alarmIsOn = false
        btnstopAlarm.isHidden = true
        btnStop.isHidden = false
        btnPause.isHidden = false
        if restMode {
            timerLabel.text = timeString(time: TimeInterval(sTomatoTime))
            runActivity()
        }else{ //tomatoMode
            if activityCount == tomato.tomatoNum {
                if delayCount == 0{ //有準時完成整個任務
                tomato.completed = true
                tomato.onTime = true
                tomato.result = 1
                }else{  // 有延期過
                    tomato.completed = true
                    tomato.onTime = false
                    tomato.result = 2
                }
            self.delegate?.timerViewControllerResponse(arrayIndex!, tomato)
                self.tabBarController?.tabBar.isHidden = false
                self.changeToTomato()
            }else {
                timerLabel.text = timeString(time: TimeInterval(sRestTime))
                runRest()
            }
        }
    }

    func alert(_ title: String, _ msg: String){
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定",style: .default) { (_) in
            self.tomato.giveup = true
            self.delegate?.timerViewControllerResponse(self.arrayIndex!, self.tomato)
            self.tabBarController?.tabBar.isHidden = false
            self.changeToTomato()
        }
       controller.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .default){(_) in
            if !self.resumeTapped {
                self.runTimer()
                self.runCircularProgress()
            }
        }
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    func showNavigation(){
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func hideNavigation(){
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    func changeToTomato(){
        showNavigation()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    func timeString(time:TimeInterval) -> String {
//        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}
protocol TimerViewControllerDelegate
{
    func timerViewControllerResponse(_ index : Int, _ tomato : Tomato )
}
    
//        @IBAction func resetButtonTapped(_ sender: UIButton) {
//             timer.invalidate()
//             seconds = 60
//
//             timerLabel.text = timeString(time: TimeInterval(seconds))
//        }
    
