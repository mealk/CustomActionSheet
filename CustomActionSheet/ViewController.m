//
//  ViewController.m
//  CustomActionSheet
//
//  Created by Mealk.Lei on 15/7/21.
//  Copyright (c) 2015年 developer. All rights reserved.
//

#import "ViewController.h"
#import "CustomActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showActionSheet:(UIButton *)sender {
    
    CustomActionSheet *action = [[CustomActionSheet alloc] initWithTitle:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Scan QR Code", nil),NSLocalizedString(@"Map", nil), nil];
    
    action.clickedButtonAtIndex = ^(NSInteger Buttonindex){
        
        NSLog(@"index--%ld",Buttonindex);
        
    };
    action.otherButtonTintColor = [UIColor colorWithRed:75/255.f green:89/255.f blue:255/255.f alpha:1.0];
    [action show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
