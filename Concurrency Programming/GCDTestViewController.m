//
//  UIViewController+GCDTestViewController.m
//  Concurrency Programming
//
//  Created by yong.pan on 6/22/16.
//  Copyright © 2016 yong.pan. All rights reserved.
//

#import "GCDTestViewController.h"

@implementation GCDTestViewController


NSDate *startDateGCD;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.valuelabel.text = @"Click button to start 400 thread test.";
    
}

- (IBAction)click:(id)sender {
    [self initGCDUseCase];
    startDateGCD =[NSDate date];
}

- (void)initGCDUseCase{
    //1.创建队列组
    dispatch_group_t group = dispatch_group_create();
    //2.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //3.多次使用队列组的方法执行任务, 只有异步方法
    //3.1.执行3次循环
    dispatch_group_async(group, queue, ^{
         for (int i = 100; i<500; i++) {
             NSString *aString = [NSString stringWithFormat:@"%d", i];
             NSString *code = [@"hk00" stringByAppendingString:aString];
            [self GetStockValue:code];
        }
    });
    
    self.spenttimelabel.text =[NSString stringWithFormat:@"Doing..."];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //NSLog(@"完成 - %@", [NSThread currentThread]);
        [self updateLabel];
        

    });

    
}

- (void)updateLabel{
    self.valuelabel.text =[NSString stringWithFormat:@"Sum = %f", self.totleValueGCD];
    //计时
    NSDate *curDate;
    curDate = [NSDate date];
    NSTimeInterval time=[curDate timeIntervalSinceDate:startDateGCD];
    self.spenttimelabel.text = [NSString stringWithFormat:@"Spend Time = %fs", time];
}

- (void)GetStockValue:(NSString*) parameter {
    //sleep(3);
    //NSLog(@"NSthreadStart--->%@", [NSThread currentThread]);
    //NSLog(@"time: %@",[NSDate date]);
    NSString *urlStr = [@"https://hq.sinajs.cn/list=" stringByAppendingString:parameter];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = [[NSURLResponse alloc]init];
    //NSLog(@"%@",url);
    
    /*
     // 发送请求 ，返回请求得到的数据。
     // 第一个参数：发送的请求
     // 当服务器返回数据后，就会将 得到的数据<响应头>，赋值给 响应中
     // 同步发送请求，  会阻塞线程，一般不使用
     //该方法已经废弃
     */
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    //明确表示用 gbkEncoding 进行解码
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *str = [[NSString alloc]initWithData:data encoding:gbkEncoding];
    //NSLog(@"%@----%@",str,response);
    //NSLog(@"NSthreadStart--->%@", [NSThread currentThread]);
    NSArray *strArray = [[NSArray alloc] init];
    double value = 0.0;
    
    strArray = [str componentsSeparatedByString:@","];
    if([strArray count]>1){
        NSString *str=[strArray objectAtIndex:2];
        //NSLog(str);
        value = [str doubleValue];
    }
    self.totleValueGCD= self.totleValueGCD+value;
    
   // [self performSelectorOnMainThread:@selector(updateLabel:) withObject:nil waitUntilDone:YES];
   
}



@end
