//
//  ViewController.h
//  BackIndicatorTest
//
//  Created by 平松 亮介 on 2013/06/02.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic) NSMutableData *receiveData;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *perLabel;

- (IBAction)startNetworkConnection:(id)sender;

@end
