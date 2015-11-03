//
//  RBMenu.h
//  AnimationDemo
//
//  Created by zruibin on 15/11/3.
//  Copyright © 2015年 RBCHOW. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RBMenuItem : NSObject

@property (readwrite, nonatomic, strong) UIImage *image;
@property (readwrite, nonatomic, strong) UIImage *hltImage;
@property (readwrite, nonatomic, strong) NSString *title;
@property (readwrite, nonatomic, assign) NSTextAlignment titleAlignment;

+ (instancetype)menuItem:(NSString *)title
                        image:(UIImage *)image
                        hltImage:(UIImage *)hltImage
                        titleAlignment:(NSTextAlignment)titleAlignment;

@end

typedef NS_ENUM(NSInteger, RBMenuArrowDirection) {
    RBMenuArrowDirectionNone,
    RBMenuArrowDirectionUp,
    RBMenuArrowDirectionUpLeft,
    RBMenuArrowDirectionUpRight,
    RBMenuArrowDirectionDown,
    RBMenuArrowDirectionDownLeft,
    RBMenuArrowDirectionDownRight,
    RBMenuArrowDirectionLeft,
    RBMenuArrowDirectionRight
};

typedef void (^OnTouchBlock)(NSInteger touchIndex, NSString *touchTitle);

@interface RBMenu : UIView

@property (nonatomic, copy) OnTouchBlock onTouchBlock;

+ (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems
         arrowDirection:(RBMenuArrowDirection)arrowDirection;

+ (void) dismissMenu;

/*设置背景颜色*/
+ (void)setTintColor:(UIColor *) tintColor;

/*设置线条颜色*/
+ (void)setLineColor:(UIColor *)lineColor;

/*设置文字颜色*/
+ (void)setTitleTintColor:(UIColor *)titleTintColor;

/*设置文字点击时的颜色*/
+ (void)setTitleHltColor:(UIColor *)titleHltColor;

/*设置点击回调*/
+ (void) makeOnTouchBlock:(OnTouchBlock) onTouchBlock;


@end
