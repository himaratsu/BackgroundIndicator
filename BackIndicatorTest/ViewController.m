//
//  ViewController.m
//  BackIndicatorTest
//
//  Created by 平松 亮介 on 2013/06/02.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
<NSURLConnectionDataDelegate>
{
    float totalBytes;
    float loadedBytes;
    
    UIBackgroundTaskIdentifier bgTask;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.progressView setProgress:0];
    self.perLabel.text = 0;
}

// 通信を開始
- (IBAction)startNetworkConnection:(id)sender {
    NSLog(@"通信を開始します...");
    
    UIApplication *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // 適当な重いファイル
    NSURL *url = [NSURL URLWithString:@"https://github.com/xcatsan/iOS-Sample-Code/archive/2011-04-08b.zip"];
    
    // プログレスバーをセット
    [self.progressView setProgress:0];
    
    // ラベルをセット
    self.perLabel.text = @"0%";
    
    // リクエスト
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

// 進捗表示
- (void)showProgress {
    float rate = (loadedBytes/totalBytes);
    int per = rate*100;
    
    // プログレスバーに表示
    [self.progressView setProgress:rate];
    
    // ラベルに表示
    self.perLabel.text = [NSString stringWithFormat:@"%d%%", per];
    
    // バッジに表示
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber = per;
    
    // ログに表示
    NSLog(@"Now Loading... [%f/%f]", loadedBytes, totalBytes);
}


// 進捗完了表示
- (void)showProgressDone {
    // プログレスバーに表示
    [self.progressView setProgress:1];
    
    // ラベルに表示
    self.perLabel.text = @"100% (Complete!)";
    
    // バッジに表示
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber = 0;
    
    // ログに表示
    NSLog(@"Loading Done!");
    
    [self notificateDone];
}


// 完了したことをLocalNotificationで通知
- (void)notificateDone {
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    localNotif.fireDate = [[NSDate date] dateByAddingTimeInterval:5];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    // 通知メッセージ
    localNotif.alertBody = [NSString stringWithFormat:@"ダウンロードが完了しました"];
    
    // 効果音は標準の効果音を利用する
    [localNotif setSoundName:UILocalNotificationDefaultSoundName];
    
    // 通知アラートのボタン表示名を指定
    localNotif.alertAction = @"Open";
    
    // 作成した通知イベントをアプリケーションに登録
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}


#pragma mark - NSURLConnectionDelegate

// レスポンス受信
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.receiveData = [NSMutableData data];
    long expectedLength = [response expectedContentLength];
    totalBytes = expectedLength;
    loadedBytes = 0;
    
    [self showProgress];
}

// データ受信
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receiveData appendData:data];
    loadedBytes += [data length];
    
    [self showProgress];
}

// データ受信完了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self showProgressDone];
    
    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
}

// エラー発生
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error!");
}


@end
