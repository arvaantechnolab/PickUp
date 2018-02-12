//
//  AMTextField.swift
//  AMTextField
//
//  Created by Amul Patel on 12/13/17.
//  Copyright © 2017 Amul Patel. All rights reserved.
//

import UIKit

let Textfild_Blue  = UIColor.clear
let Textfild_Gray  = UIColor.clear
let Border = UIColor.clear
let Textfild_BGColor = UIColor.clear
let TesxtFildshadow:CGFloat = 50.0
let Border_Width : CGFloat=1
let iCON_MARGIN : CGFloat=15

class AMTextField:UITextField
{
    var leftIconImageView = UIImageView()
    var lineImageView = UIImageView()
    var lineSize = CGFloat()
    var rightIconImageView = UIImageView()
    

    
    @IBInspectable var backGroundColor:UIColor = Textfild_Blue
    {
        didSet{
            self.layer.backgroundColor = backGroundColor.cgColor
            
        }
    }
    @IBInspectable var textFieldBorderColor: UIColor = Border
    {
        didSet
        {
            self.layer.borderColor = textFieldBorderColor.cgColor
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "",
                                                            attributes:[NSAttributedStringKey.foregroundColor: textFieldBorderColor])
        }
    }
    
    @IBInspectable var fontColor: UIColor = Textfild_Blue {
        
        didSet {
            
            self.textColor = fontColor
            
        }
    }
    /// Tetxfield Placeholder Color
    @IBInspectable var palceHolderColor: UIColor = Textfild_Gray
    
    //Inset X  for TextField
    @IBInspectable var insetX: CGFloat = 0
    
    //Inset Y  for TextField
    @IBInspectable var insetY: CGFloat = 0
    
    // Height of Line
    @IBInspectable var LineSize: CGFloat = Border_Width
    {
        didSet

        {
           lineSize = LineSize
            
        }
    }
   
    @IBInspectable var lineImage :UIColor = Textfild_Blue
    {
         didSet {
           
            lineImageView.backgroundColor = lineImage
            
        }
    }
    //LeftImage  for TextField
    @IBInspectable var leftImage : String = "" {
        
        didSet {
            var imageName : String = ""
            if(leftImage.contains("Icon")){
                
                imageName = leftImage
                
            }else{
                
                imageName = "\(leftImage)"
            }
            
            let image = UIImage(named: imageName)
            leftIconImageView.frame = CGRect(x: 6, y: 0 ,width: (image!.size.width - 7.5) ,height: ((image?.size.height)! - 7.5 ))
            leftIconImageView.image = image;
            
        }
    }
    
    @IBInspectable var rightImage : String = "" {
        
        didSet {
            var imageName : String = ""
            if(rightImage.contains("Icon")){
                
                imageName = rightImage
                
            }else{
                
                imageName = "\(rightImage)"
            }
            
            let image = UIImage(named: imageName)
            rightIconImageView.frame = CGRect(x: 3, y: 0 ,width: (image!.size.width ) ,height: (image?.size.height)!)
            rightIconImageView.image = image;
            
        }
    }
    
    //==========================================
    //MARK: - UIView : Draw Rect
    //==========================================
    
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        //setupTextField()
        
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
     
        self.layer.backgroundColor = self.backGroundColor.cgColor;
        self.clipsToBounds = true;
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //setupTextField()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }
    
    //==========================================
    //MARK: - UIView : Awake From Nib
    //==========================================
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        setupTextField()
        
    }
    
    
    
    
    //==========================================
    //MARK: - Setup Textfield
    //==========================================
    
    func setupTextField () {
        
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "",
                                                        attributes:[NSAttributedStringKey.foregroundColor: palceHolderColor])
        
        self.layer.backgroundColor = self.backGroundColor.cgColor;
        self.clipsToBounds = true;
        self.textColor = fontColor
        self.placeholder = self.placeholder
        leftViewMode = UITextFieldViewMode.always
        rightViewMode = UITextFieldViewMode.always
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftIconImageView.frame.size.width + 12 , height: leftIconImageView.frame.size.height))
        leftPaddingView.addSubview(leftIconImageView)
//        leftPaddingView.backgroundColor = UIColor.red
        leftView = leftPaddingView;
        
        let rightPaddingView = UIView(frame: CGRect(x: (self.frame.size.width - rightIconImageView.frame.size.width + 12) , y: 0, width: rightIconImageView.frame.size.width + 12 , height: rightIconImageView.frame.size.height))
        rightPaddingView.addSubview(rightIconImageView)
//        rightPaddingView.backgroundColor = UIColor.yellow
        rightView = rightPaddingView;
        
    
        lineImageView.frame = CGRect(x: 0, y:self.layer.frame.height - lineSize  ,width:self.bounds.width + 200 ,height: lineSize)
        let bottoumPadding = UIView(frame: CGRect(x: 0, y: 0, width: lineImageView.frame.width, height: lineImageView.frame.height))
        bottoumPadding.addSubview(lineImageView)
        
        self.addSubview(bottoumPadding)
        
    
    }
   
    
    func startEditing(){
        leftIconImageView.image = UIImage(named: "\(leftImage)");
        rightIconImageView.image  = UIImage(named: "\(rightImage)");
    }
    
    func endEditing(){
        leftIconImageView.image = UIImage(named: "\(leftImage)");
        rightIconImageView.image = UIImage(named: "\(rightImage)");
    }
    
    
    //===================================================
    //MARK: - UITextField drawing and positioning Methods
    //===================================================
    
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX , dy: insetY)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX , dy: insetY)
    }
    
}


class DBLocalizedTextField : UITextField{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.placeholder = self.placeholder
    }
}

