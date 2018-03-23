//
//  ViewController.swift
//  MasterMind
//
//  Created by J.B. Hoekstra on 23/02/2018.
//  Copyright © 2018 Team4. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    var widthMultiplier = 0.0
    var heightMultiplier = 0.0
    var playerCode = [String]()
    var opponentCode = ["r","r","r","b"] //[String]()
    var fillButton = 0
    var turn = 0
    
    @IBOutlet var allLabels: [UILabel]!
    @IBOutlet var allButtons: [UIButton]!
    @IBOutlet weak var upperText: UILabel!
    @IBOutlet var Buttons: [UIButton]!
    @IBOutlet var colorSelection: [UIButton]!
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet var opponentEvals: [UILabel]!
    @IBOutlet var playerEvals: [UILabel]!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet var playerCodeLabels: [UILabel]!
    @IBOutlet weak var confirmButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widthMultiplier = Double(self.view.frame.size.width) / 375
        heightMultiplier = Double(self.view.frame.size.height) / 667
        scaleView(labels: allLabels)
        scaleView(buttons: allButtons)
        circleButtons(buttons: Buttons)
        circleButtons(buttons: colorSelection)
        circleButtons(labels: playerCodeLabels)
        setCode()

    }

    func setCode(){
        for x in 0...3{
            switch playerCode[x]{
                case "r": playerCodeLabels[x].backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                case "y": playerCodeLabels[x].backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
                case "g": playerCodeLabels[x].backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
                case "b": playerCodeLabels[x].backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                case "p": playerCodeLabels[x].backgroundColor = #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)
                case "w": playerCodeLabels[x].backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                default: print("could not find code")
            }
        }
    }
    
    func scaleView(labels:[UILabel]!){
        for label in labels{
            label.frame.size.width = label.frame.width * CGFloat(widthMultiplier)
            label.frame.size.height = label.frame.height * CGFloat(heightMultiplier)
            label.frame.origin = CGPoint(x: label.frame.origin.x * CGFloat(widthMultiplier), y: label.frame.origin.y * CGFloat(heightMultiplier))
        }
    }
    
    func scaleView(buttons:[UIButton]!){
        for button in buttons{
            button.frame.size.width = button.frame.width * CGFloat(widthMultiplier)
            button.frame.size.height = button.frame.height * CGFloat(heightMultiplier)
            button.frame.origin = CGPoint(x: button.frame.origin.x * CGFloat(widthMultiplier), y: button.frame.origin.y * CGFloat(heightMultiplier))
            button.titleLabel?.minimumScaleFactor = 0.5
            button.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    func circleButtons(buttons:[UIButton]!){
        for button in buttons{
            button.layer.cornerRadius = (button.frame.width)/2
            button.clipsToBounds = true
        }
    }
    
    func circleButtons(labels:[UILabel]!){
        for label in labels{
            label.layer.cornerRadius = (label.frame.width)/2
            label.clipsToBounds = true
        }
    }
    
    @IBAction func fillColor(_ sender: UIButton) {
        for color in colorSelection{
            color.isHidden = false
        }
        fillButton = Buttons.index(of: sender)!
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        let currentButton = colorSelection.index(of: sender)!
        Buttons[fillButton].backgroundColor = colorSelection[currentButton].backgroundColor
        for color in colorSelection{
            color.isHidden = true
        }
    }
    
    @IBAction func confirmChoice(_ sender: Any) {
        var turnDone = true
        for x in 0...3{
            if Buttons[x + (4*turn)].backgroundColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1){
                turnDone = false
                //print("Button \(x+(4*turn)) has not been set")
            }
        }
        if turnDone{
            if upperText.text != "You win" && upperText.text != "You lose"{
                checkCode()
            }
            //print("turn is over")
        }
        else{
            //print("turn not done yet")
        }
    }
    
    func checkCode(){
        evaluate()
        if upperText.text != "You win" && upperText.text != "You lose"{
            turn += 1
            turnLabel.text = "Turn: \(turn+1)"
            if turn < 8{
                for x in 0...3{
                    Buttons[x + (4*turn)].isHidden = false
                }
            }
            else{
                upperText.text = "You lose"
                confirmButton.isHidden = true
            }
        }
    }
    
    func evaluate(){
        var code = opponentCode
        var pCode = playerCode
        var pwhite = 0
        var pblack = 0
        var owhite = 0
        var oblack = 0
        var choice = [String]()
        
        //opponentEval
        for x in 0...3{
            Buttons[x + (4*turn)].isEnabled = false
            choice.append(color2code(ind: x+(4*turn)))
            if choice[x] == code[x]{
                pblack += 1
                playerEvals[turn].text?.append("⚫️")
                code[x] = "done"
                choice[x] = "done"
            }
        }

        for x in 0...3{
            if choice[x] != "done"{
                if code.contains(choice[x]){
                    pwhite += 1
                    playerEvals[turn].text?.append("⚪️")
                    code[code.index(of: choice[x])!] = "done"
                    choice[x] = "done"
                }
            }
        }
        
        //playerEval
        for x in 0...3{
            Buttons[x + (4*turn)].isEnabled = false
            choice[x] = color2code(ind: x+(4*turn))
            if choice[x] == playerCode[x]{
                oblack += 1
                opponentEvals[turn].text?.append("⚫️")
                pCode[x] = "done"
                choice[x] = "done"
            }
        }
        
        for x in 0...3{
            if choice[x] != "done"{
                if playerCode.contains(choice[x]){
                    owhite += 1
                    opponentEvals[turn].text?.append("⚪️")
                    pCode[playerCode.index(of: choice[x])!] = "done"
                    choice[x] = "done"
                }
            }
        }
        
        //eval
        if pblack == 4{
            upperText.text = "You win"
            confirmButton.isHidden = true
        }
        if oblack == 4{
            upperText.text = "You lose"
            confirmButton.isHidden = true
        }
        
    }
    
    func color2code(ind:Int) -> String{
        //buttonColor = Buttons[ind].backgroundColor
        switch Buttons[ind].backgroundColor! {
        case colorSelection[0].backgroundColor!: return colorSelection[0].currentTitle!
        case colorSelection[1].backgroundColor!: return colorSelection[1].currentTitle!
        case colorSelection[2].backgroundColor!: return colorSelection[2].currentTitle!
        case colorSelection[3].backgroundColor!: return colorSelection[3].currentTitle!
        case colorSelection[4].backgroundColor!: return colorSelection[4].currentTitle!
        case colorSelection[5].backgroundColor!: return colorSelection[5].currentTitle!
        default: print("could not find color: \(Buttons[ind].backgroundColor!)"); return "e"
        }
    }

    
    @IBAction func reset(_ sender: Any) {
        turn = 0
        for x in 0...(Buttons.endIndex-1){
            Buttons[x].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            Buttons[x].isEnabled = true
            if x > 3{
                Buttons[x].isHidden = true
            }
            else{
                Buttons[x].isHidden = false
            }
        }
        for x in 0...(playerEvals.endIndex-1){
            playerEvals[x].text = ""
        }
        turnLabel.text = "Turn: 1"
        upperText.text = "Your turn"
        confirmButton.isHidden = false
    }
    
    //TODO: confirmation pins

    //TODO: scaling buttons

}

