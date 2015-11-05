//
//  ViewController.m
//  RBMenuDemo
//
//  Created by zruibin on 15/11/3.
//  Copyright © 2015年 zruibin. All rights reserved.
//

#import "ViewController.h"
#import "RBMenu.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)upLeftAction:(UIButton *)sender {
    [self makeTheMenu:sender.frame];
}

- (IBAction)upRightAction:(UIButton *)sender {
   [self makeTheMenu:sender.frame];
}

- (IBAction)leftAction:(UIButton *)sender {
   [self makeTheMenu:sender.frame];
}

- (IBAction)rightAction:(UIButton *)sender {
   [self makeTheMenu:sender.frame];
}

- (IBAction)downLeftAction:(UIButton *)sender {
   [self makeTheMenu:sender.frame];
}

- (IBAction)downRightAction:(UIButton *)sender {
   [self makeTheMenu:sender.frame];
}

- (IBAction)upAction:(UIButton *)sender
{
   [self makeTheMenu:sender.frame];
}

- (IBAction)downAction:(UIButton *)sender
{
   [self makeTheMenu:sender.frame];
}

- (IBAction)centerAction:(UIButton *)sender {
    [self makeTheMenu:sender.frame];
}


- (void)makeTheMenu:(CGRect)rect
{
    NSArray *items = @[
                       [RBMenuItem menuItem:@"1111" image:[UIImage imageNamed:@"rateDark"] hltImage:[UIImage imageNamed:@"rateLight"] titleAlignment:0],
                       [RBMenuItem menuItem:@"22222222" image:[UIImage imageNamed:@"rateDark"] hltImage:nil titleAlignment:0],
                       [RBMenuItem menuItem:@"433333" image:nil hltImage:nil titleAlignment:NSTextAlignmentCenter],
                       [RBMenuItem menuItem:@"44444" image:[UIImage imageNamed:@"rateDark"] hltImage:[UIImage imageNamed:@"rateLight"] titleAlignment:0],
                       [RBMenuItem menuItem:@"55555" image:[UIImage imageNamed:@"rateDark"] hltImage:[UIImage imageNamed:@"rateLight"] titleAlignment:0]
                       ];
    
    [RBMenu showMenuInView:self.view fromRect:rect menuItems:items];
    
//    [RBMenu setMenuWidth:160.0f];
//    [RBMenu setTintColor:[UIColor redColor]];
//    [RBMenu setLineColor:[UIColor greenColor]];
//    [RBMenu setTitleTintColor:[UIColor blackColor]];
//    [RBMenu setTitleHltColor:[UIColor greenColor]];
    
    [RBMenu makeOnTouchBlock:^(NSInteger touchIndex, NSString *touchTitle) {
        NSLog(@"index:%ld, title:%@", (long)touchIndex, touchTitle);
    }];
    

}

@end









