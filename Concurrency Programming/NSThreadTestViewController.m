//
//  ViewController.m
//  Concurrency Programming
//
//  Created by yong.pan on 6/12/16.
//  Copyright © 2016 yong.pan. All rights reserved.
//

#import "NSThreadTestViewController.h"
#import <pthread.h>

@interface NSThreadTestViewController()



@end

@implementation NSThreadTestViewController
double totleValue = 0.0;
NSDate *startDate;
NSLock *lock ;


- (IBAction)click:(id)sender {
    [self computerNetworkAssetValue];
    startDate =[NSDate date];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _myLabel.text = @"Click button to start 400 thread test.";
    lock = [[NSLock alloc] init];
}



- (void)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)pthreadUseCase{
    //这里是底层 c代码的thread 需要 import <pthread.h>
    pthread_t thread;
    //创建一个线程并自动执行
    pthread_create(&thread, NULL, pthreadStart, NULL);
}


- (void)NSthreadUseCase{
    // 创建一个
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(NSthreadStart:) object:@"hk00701"];
    
    // 启动
    [thread start];
    
}

/*
 计算网络拉取数据
 */
- (void)computerNetworkAssetValue{
    self.totleValue = 0.0;
    totleValue = 0.0;
    for (int i = 100; i<500; i++) {
        NSString *aString = [NSString stringWithFormat:@"%d", i];
        NSString *code = [@"hk00" stringByAppendingString:aString];
        //NSLog(code);
        [self getCurrentStockPrice:code];
    }
}

- (double) getCurrentStockPrice:(NSString*) stockcode{
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(NSthreadStart:) object:stockcode];
    thread.name = stockcode;
    // 启动
    [thread start];
    return 0.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

void *pthreadStart(void *data) {
    NSLog(@"pthreadStart--->%@", [NSThread currentThread]);
    NSLog(@"time: %@",[NSDate date]);
    return NULL;
}

- (void)updateLabel:(NSNumber*) v{
    self.myLabel.text =[NSString stringWithFormat:@"Sum = %f", self.totleValue];
    //计时
    NSDate *curDate;
    curDate = [NSDate date];
    NSTimeInterval time=[curDate timeIntervalSinceDate:startDate];
    self.myLabelTime.text = [NSString stringWithFormat:@"Spend Time = %fs", time];
}

- (void)NSthreadStart:(NSString*) parameter {
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
    //使用锁 管理一个公共变量值
    [lock lock];
    self.totleValue= self.totleValue+value;
    [lock unlock];
    
    [self performSelectorOnMainThread:@selector(updateLabel:) withObject:nil waitUntilDone:YES];
    [[NSThread currentThread] cancel];
    
    [NSThread exit];
}

@end
// 小结
// 使用NSThread开启几百个线程，会吃掉很多应用内存，线程结束后会释放，但并发过程没有现成的 线程池管理，大数并发不利，NSthread适合简单启动一个小工作。

