//
//  ViewController.h
//  Concurrency Programming
//
//  Created by yong.pan on 6/12/16.
//  Copyright © 2016 yong.pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSThreadTestViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UIButton *myButton;

@property (weak, nonatomic) IBOutlet UILabel *myLabelTime;

@property(assign,atomic) double totleValue;

@end

