//
//  ViewController.m
//  ZKUDIDManager
//
//  Created by Jack on 2/19/16.
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
    NSString *UDID = [ZKUDIDManager value];
    NSLog(@"%@",UDID);
    
    NSString *UUIDFVString = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSLog(@"%@",UUIDFVString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
