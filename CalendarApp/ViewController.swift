//
//  ViewController.swift
//  CalendarApp
//
//  Created by Leo Vergnetti on 1/26/19.
//  Copyright © 2019 Leo Vergnetti. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addEventButton: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var dayButtons: [UIButton]!
    let transLayer : UIView = UIView()
    var dateIsSelected = false
    let eventCategories = ["Work", "School", "Family", "Birthday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let firstWeekdayOfMonth = Date().firstDayOfMonth() - 1
        for button in dayButtons.enumerated(){
            if button.offset < firstWeekdayOfMonth || button.offset > 32{
                button.element.setTitle("", for: .normal)
            } else if button.offset == 6 || button.offset == 9{
                let finishedButton = drawEventCircleOnButton(events: [1,2,3,5], button: button.element)
                finishedButton.setTitleColor(UIColor.black, for: .normal)
                finishedButton.setTitle("\(button.offset-5)", for: .normal)
            } else{
                button.element.setTitleColor(UIColor.black, for: .normal)
                button.element.setTitle("\(button.offset + 1 - firstWeekdayOfMonth)", for: .normal)
            }
        }
    }
    
    func drawEventCircleOnButton(events : [Int], button : UIButton) -> UIButton {
        for i in 1 ... events.count {
            let colors = getColorArray()
            let diskLayer = CAShapeLayer()
            let ovalPath = UIBezierPath(arcCenter: CGPoint(x: button.frame.size.width/2, y: button.frame.size.height/2),
                                         radius: button.frame.size.height/3,
                                         startAngle: CGFloat(Double(i - 1) * 360.0 / Double(events.count) ).toRadians(),
                                         endAngle: CGFloat(Double(i) * 360.0 / Double(events.count)).toRadians(),
                                         clockwise: true)
            diskLayer.path = ovalPath.cgPath
            diskLayer.strokeColor = colors[i-1]
            diskLayer.lineWidth = 4.0
            diskLayer.fillColor = UIColor.clear.cgColor
            button.layer.addSublayer(diskLayer)
        }
        return button
    }
    
    func getColorArray() -> [CGColor]{
        let red = UIColor.init(red:0.84, green:0.19, blue:0.19, alpha:1.0)
        let green = UIColor(red:0.00, green:0.72, blue:0.58, alpha:1.0)
        let blue = UIColor(red:0.04, green:0.52, blue:0.89, alpha:1.0)
        let yellow = UIColor(red:1.00, green:0.92, blue:0.65, alpha:1.0)
        
        return [red.cgColor, green.cgColor, blue.cgColor, yellow.cgColor]
    }
    
    @IBAction func dateClicked(_ sender: UIButton) {
        if dateIsSelected == true{
            dateIsSelected = false
            transLayer.removeFromSuperview()
            sender.setTitleColor(UIColor.black, for: .normal)
            monthLabel.textColor = UIColor.black
            backgroundView.addSubview(sender)
            backgroundView.addSubview(monthLabel)
        }else{
            transLayer.frame.size.height = backgroundView.frame.size.height
            transLayer.frame.size.width = backgroundView.frame.size.width
            transLayer.backgroundColor = UIColor.black
            transLayer.alpha = 0.75
            backgroundView.addSubview(transLayer)
            sender.setTitleColor(UIColor.white, for: .normal)
            monthLabel.textColor = UIColor.white
            transLayer.addSubview(sender)
            transLayer.addSubview(monthLabel)
            dateIsSelected = true
        }
    }
    
}

extension CGFloat{
    func toRadians() -> CGFloat{
        return self * CGFloat.pi/180
    }
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    func firstDayOfMonth() -> Int {
        return Calendar.current.component(.weekday, from: Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!)
    }
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    
}
