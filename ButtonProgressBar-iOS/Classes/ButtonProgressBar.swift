//
//  ButtonProgressBar.swift
//  ButtonProgressBar-iOS
//
//  Created by Pushkar Sharma on 08/04/2017.
//  Copyright © 2017 thePsguy. All rights reserved.
//

import UIKit

public class ButtonProgressBar: UIButton {
    
    private var cornerRadius: CGFloat = 5
    public private(set) var progress: CGFloat = 0.0
    
    var indeterminate: Bool = false
    
    private let progressLayer = CAShapeLayer()
    
    private var progressColor = UIColor(red: 2/255, green: 119/255, blue: 189/255, alpha: 1.0)
    private var timePadding: Double = 0.5
    
    private var timer: Timer?

    public let label = UILabel()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        backgroundColor = UIColor(red: 45/255, green: 92/255, blue: 196/255, alpha: 1.0)
        
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        label.textAlignment = .center
        label.textColor = .white
        
        progressLayer.path = rectanglePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        
        progressLayer.strokeEnd = 0.0
        progressLayer.lineWidth = frame.height*2
        
        progressLayer.strokeEnd = 0.0
        
        layer.addSublayer(progressLayer)
        self.addSubview(label)
    }
    
    public func startIndeterminate(withTimePeriod time: TimeInterval) {
        timer?.invalidate()
        self.resetProgress()
        timer = Timer.scheduledTimer(timeInterval: time,
                                     target: self,
                                     selector: #selector(self.animateIndeterminate),
                                     userInfo: time,
                                     repeats: true)
        timer?.fire()
        RunLoop.current.add(timer!, forMode: .defaultRunLoopMode)
    }
    
    func animateIndeterminate(sender: Timer) {
        let time = sender.userInfo as! Double - timePadding
        let stroke = CABasicAnimation(keyPath: "strokeEnd")
        stroke.fromValue = 0.0
        stroke.toValue = 0.5
        stroke.duration = time
        stroke.fillMode = kCAFillModeForwards
        stroke.isRemovedOnCompletion = false
        stroke.timingFunction = CAMediaTimingFunction(controlPoints: 1, 0, 1, 1)
        self.progressLayer.add(stroke, forKey: nil)
    }
    
    public func startIndeterminate(){
        startIndeterminate(withTimePeriod: 2.0)
    }
    
    public func stopIndeterminate() {
        timer?.invalidate()
    }
    
    public func resetProgress() {
        self.setProgress(progress: 0.0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func layoutSubviews() {
        label.frame = self.bounds
        label.font = label.font.withSize(label.frame.height * 0.5)
    }
    
    public func setProgress(progress: CGFloat) {
        self.progress = progress
        progressLayer.strokeEnd = progress / 2
    }
    
    func setProgressColor(color: UIColor) {
        self.progressColor = color
        self.progressLayer.strokeColor = color.cgColor
    }

    func setBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.05) {
            self.label.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.9)
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(1.0)
        }
    }
    
}
