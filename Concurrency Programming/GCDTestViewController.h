//
//  UIViewController+GCDTestViewController.h
//  Concurrency Programming
//
//  Created by yong.pan on 6/22/16.
//  Copyright © 2016 yong.pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCDTestViewController: UIViewController
@property (weak, nonatomic) IBOutlet UILabel *valuelabel;
@property (weak, nonatomic) IBOutlet UILabel *spenttimelabel;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property(assign,atomic) double totleValueGCD;

@end
