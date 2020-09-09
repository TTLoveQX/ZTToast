//
//  PKZTToast.swift
//  PKApp
//
//  Created by Leery on 2018/11/8.
//  Copyright © 2018 LZT. All rights reserved.
//

import UIKit

enum PKZTToastLocation {
    case top;
    case center;
    case bottom;
}

class PKZTToast: UIView {
    
    var textString:String?
    var duration:TimeInterval?
    var location:PKZTToastLocation?
    var mainView:UIView?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.layer.cornerRadius = 4.0
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     * 根据文字显示toast
     * @program text : 提示文字
     * @program duration : 显示时间，最少2(s)
     * @program location : 显示位置(上、中、下)
     */
    class func showToast(text: String,
                         duration:TimeInterval,
                         location:PKZTToastLocation) {
        if text.count == 0 {
            return
        }
        var dur = duration
        if dur < 2 {
            dur = 2
        }
        let toast = PKZTToast(frame: CGRect(x: 40, y: 100, width: 80, height: 40))
        toast.textString = text
        toast.duration = duration
        toast.location = location
        
        var size = getSize(withString: text, size: CGSize(width: ScreenW - 20, height: ScreenH - 40), font: defaultSystemFont(withSize: 15))
        if size.height < 40 {
            size.height = 40
        }
        if size.width < 80 {
            size.width = 80
        }
        var orignY:CGFloat = 100
        switch location {
        case .top:
            orignY = 100
            break
        case .bottom:
            orignY = ScreenH - TOOLBAR_HEIGHT - size.height - 30
            break
        case .center:
            orignY = (ScreenH - size.height - 20) / 2
            break
        }
        toast.frame = CGRect(x: (ScreenW - size.width - 20) / 2, y: orignY, width: size.width + 20, height: size.height + 20)
        
        let contentLabel = UILabel(frame: toast.bounds)
        contentLabel.text = text
        contentLabel.textColor = .white
        contentLabel.textAlignment = .center
        contentLabel.font = defaultSystemFont(withSize: 15)
        contentLabel.numberOfLines = 0
        toast.addSubview(contentLabel)
        
        let window = UIApplication.shared.keyWindow
        let maskView = UIView(frame: (window?.bounds)!)
        maskView.backgroundColor = UIColor.clear
        toast.mainView = maskView
        window?.addSubview(toast.mainView!)
        window?.addSubview(toast)
        
        addScaleAnimationWith(view: toast, duration: 0.35)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dur) {
            toast.hide()
        }
    }
    
    func dismiss() {
        self.hide()
    }
    
    private func hide() {
        removeScaleAnimationWith(view: self, duration: 0.2)
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            self.mainView?.isUserInteractionEnabled = false
            self.mainView?.alpha = 0.01
        }) { (isFinished) in
            self.mainView?.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
}
