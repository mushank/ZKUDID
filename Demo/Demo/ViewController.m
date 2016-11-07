//
//  ViewController.m
//  ZKUDIDManager
//
//  Created by Jack on 3/28/16.
//  Copyright © 2016 mushank. All rights reserved.
//

#import "ViewController.h"
#import "ZKUDIDManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Example Code
    [ZKUDIDManager setDebug:YES];   // default is NO.
    NSString *UDID = [ZKUDIDManager value];
    NSLog(@"UDID: %@",UDID);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
