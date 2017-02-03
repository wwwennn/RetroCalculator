//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Zhong Wen on 2/2/17.
//  Copyright © 2017 Wen Zhong. All rights reserved.
//

import UIKit
import AVFoundation
// 新引进了这个包

class ViewController: UIViewController {
    
    @IBOutlet weak var outputLbl: UILabel!
    var btnSound: AVAudioPlayer!
    // 引进声音
    
    var runningNumber = ""
    
    enum Operation: String{
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
        case Clear = "Clear"
    }

    var currentOperation = Operation.Empty
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 拿到sound的path并且建成相应的URL
        let path = Bundle.main.path(forResource: "btn", ofType:"wav")
        let soundURL = URL(fileURLWithPath:path!)
        
        // 播放前的准备工作
        do{
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        }catch let err as NSError{
            print(err.debugDescription)
        }
        
        outputLbl.text = "0"
    }
    
    // 将这个IBAction连接到相应的Button上面，本例中就是计算器中的数字buttons
    @IBAction func numberPressed(sender: UIButton){
        playSound()
        
        runningNumber += "\(sender.tag)"
        outputLbl.text = runningNumber
    }
    
    @IBAction func onDividePressed(sender: AnyObject){
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject){
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject){
        processOperation(operation: .Subtract)
    }
    
    @IBAction func onAddPressed(sender: AnyObject){
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject){
        processOperation(operation: currentOperation)
    }
    
    @IBAction func onClearPressed(sender: AnyObject){
        processOperation(operation: .Clear)
    }
    
    // 如果用户按的很快的话，先停掉之前的sound，再播放新的sound
    func playSound(){
        if btnSound.isPlaying {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
    func processOperation(operation: Operation){
        playSound()
        
        if operation == Operation.Clear {
            runningNumber = ""
            leftValStr = ""
            rightValStr = ""
            result = ""
            outputLbl.text = "0"
            currentOperation = Operation.Empty
        } else {
            
            if currentOperation != Operation.Empty {
                if runningNumber != "" {
                    rightValStr = runningNumber
                    runningNumber = ""
                    
                    if currentOperation == Operation.Divide {
                        result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                    } else if currentOperation == Operation.Multiply {
                        result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                    } else if currentOperation == Operation.Subtract {
                        result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                    } else if currentOperation == Operation.Add {
                        result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                    }
                    
                    leftValStr = result
                    outputLbl.text = result
                }
                
                currentOperation = operation
            } else {
                leftValStr = runningNumber
                runningNumber = ""
                currentOperation = operation
            }
            
        }
    }
}

