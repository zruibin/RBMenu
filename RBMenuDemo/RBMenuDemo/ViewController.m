//
//  ViewController.m
//  RBMenuDemo
//
//  Created by zhouruibin on 15/11/3.
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
    [self makeTheMenu:sender.frame arrowDirection:RBMenuArrowDirectionUpLeft];
}

- (IBAction)upRightAction:(UIButton *)sender {
   [self makeTheMenu:sender.frame arrowDirection:RBMenuArrowDirectionUpRight];
}

- (IBAction)leftAction:(UIButton *)sender {
   [self makeTheMenu:sender.frame arrowDirection:RBMenuArrowDirectionLeft];
}

- (IBAction)rightAction:(UIButton *)sender {
   [self makeTheMenu:sender.frame arrowDirection:RBMenuArrowDirectionRight];
}

- (IBAction)downLeftAction:(UIButton *)sender {
   [self makeTheMenu:sender.frame arrowDirection:RBMenuArrowDirectionDownLeft];
}

- (IBAction)downRightAction:(UIButton *)sender {
   [self makeTheMenu:sender.frame arrowDirection:RBMenuArrowDirectionDownRight];
}

- (IBAction)upAction:(UIButton *)sender
{
   [self makeTheMenu:sender.frame arrowDirection:RBMenuArrowDirectionUp];
}

- (IBAction)downAction:(UIButton *)sender
{
   [self makeTheMenu:sender.frame arrowDirection:RBMenuArrowDirectionDown];
}



- (void)makeTheMenu:(CGRect)rect arrowDirection:(RBMenuArrowDirection)arrowDirect
{
    NSArray *items = @[
                       [RBMenuItem menuItem:@"1111" image:[UIImage imageNamed:@"rateDark"] hltImage:[UIImage imageNamed:@"rateLight"] titleAlignment:0],
                       [RBMenuItem menuItem:@"22222222" image:[UIImage imageNamed:@"rateDark"] hltImage:nil titleAlignment:0],
                       [RBMenuItem menuItem:@"433333" image:nil hltImage:nil titleAlignment:NSTextAlignmentCenter],
                       [RBMenuItem menuItem:@"44444" image:[UIImage imageNamed:@"rateDark"] hltImage:[UIImage imageNamed:@"rateLight"] titleAlignment:0],
                       [RBMenuItem menuItem:@"55555" image:[UIImage imageNamed:@"rateDark"] hltImage:[UIImage imageNamed:@"rateLight"] titleAlignment:0]
                       ];
    
    [RBMenu showMenuInView:self.view fromRect:rect menuItems:items arrowDirection:arrowDirect];
    
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









