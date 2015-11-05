//
//  RBMenu.m
//  RBMenu
//
//  Created by  zruibin on 15/11/3.
//  Copyright © 2015年 RBCHOW. All rights reserved.
//

#import "RBMenu.h"

#pragma mark - RBMenuItem

#define RBMENU_VIEW_TAG 101101

@implementation RBMenuItem

+ (instancetype)menuItem:(NSString *)title
                        image:(UIImage *)image
                        hltImage:(UIImage *)hltImage
                        titleAlignment:(NSTextAlignment)titleAlignment;
{
    RBMenuItem *item = [[RBMenuItem alloc] init];
    item.title = title;
    item.image = image;
    item.hltImage = hltImage;
    item.titleAlignment = titleAlignment;
    return item;
}

@end

#pragma mark - RBMenuOverlay

@interface RBMenuOverlay : UIView
@end

@class RBMenu;

@implementation RBMenuOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        UITapGestureRecognizer *gestureRecognizer;
        gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(singleTap:)];
        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}


- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    for (UIView *v in self.subviews) {
        if (v.tag == RBMENU_VIEW_TAG) {
            
            CGPoint pt = [recognizer locationInView:self];
            UIView *view = [self hitTest:pt withEvent:nil];
            if (view != v) {
                [RBMenu  dismissMenu];
            }
        }
    }
}

@end

#pragma mark - RBMenuView

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

@interface RBMenuView : UIView

@property (nonatomic, assign) RBMenuArrowDirection arrowDirection;
@property (nonatomic, assign) NSInteger touchIndex;
@property (nonatomic, strong) UIColor *gTintColor;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *titleTintColor;
@property (nonatomic, strong) UIColor *titleHltColor;
@property (nonatomic, assign) NSTextAlignment titleAlignment;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, assign) CGRect relateRect;

@property (nonatomic, copy) OnTouchBlock onTouchBlock;

- (void)showMenuInView:(UIView *)view
            fromRect:(CGRect)rect
            menuItems:(NSArray *)menuItems;

- (void) dismiss;

- (RBMenuArrowDirection)configTheArrowDirection:(CGRect)rect;
- (CGRect)configTheRect:(CGRect)rect;

@end

static CGFloat ITEM_WIDTH = 120.0f;
static const CGFloat ITEM_HEIGHT = 40.0f;
static NSInteger ITEMS = 0;

@implementation RBMenuView

+ (RBMenuView *)shareMenu
{
    static RBMenuView *menuView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menuView = [[RBMenuView alloc] init];
        menuView.backgroundColor = [UIColor clearColor];
        menuView.gTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        menuView.lineColor =  [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4];
        menuView.titleTintColor = [UIColor whiteColor];
        menuView.titleHltColor = [UIColor orangeColor];
        menuView.tag = RBMENU_VIEW_TAG;
    });
    return menuView;
}

#pragma mark -

- (void)drawRect:(CGRect)rect
{
    [self drawTriangle:rect];
    [self drawBackground:rect];
    [self drawLine:rect];
    [self drawItems];
}

- (void)drawTriangle:(CGRect)rect
{
    CGFloat x01 = 0, y01 =0, x02 = 0, y02 = 0, x03 = 0, y03 = 0;

    switch (_arrowDirection) {
        
        case RBMenuArrowDirectionUpLeft:
        {
            x01 = CGRectGetMidX(rect) - CGRectGetMidX(rect) / 2;
            y01 = 0;
            x02 = CGRectGetMidX(rect) - CGRectGetMidX(rect) / 2 - 10;
            y02 = 10;
            x03 = CGRectGetMidX(rect) -  CGRectGetMidX(rect) / 2 + 10;
            y03 = 10;
            break;
        }
        case RBMenuArrowDirectionUpRight:
        {
            x01 = CGRectGetMidX(rect) + CGRectGetMidX(rect) / 2;
            y01 = 0;
            x02 = CGRectGetMidX(rect) + CGRectGetMidX(rect) / 2 - 10;
            y02 = 10;
            x03 = CGRectGetMidX(rect) + CGRectGetMidX(rect) / 2 + 10;
            y03 = 10;
            break;
        }
        case RBMenuArrowDirectionDownLeft:
        {
            x01 = CGRectGetMidX(rect) - CGRectGetMidX(rect) / 2;
            y01 = CGRectGetHeight(rect);
            x02 = CGRectGetMidX(rect) - CGRectGetMidX(rect) / 2 - 10;
            y02 = CGRectGetHeight(rect) - 10;
            x03 = CGRectGetMidX(rect) -  CGRectGetMidX(rect) / 2 + 10;
            y03 = CGRectGetHeight(rect) - 10;
            break;
        }
        case RBMenuArrowDirectionDownRight:
        {
            x01 = CGRectGetMidX(rect) + CGRectGetMidX(rect) / 2;
            y01 = CGRectGetHeight(rect);
            x02 = CGRectGetMidX(rect) + CGRectGetMidX(rect) / 2 - 10;
            y02 = CGRectGetHeight(rect) - 10;
            x03 = CGRectGetMidX(rect) + CGRectGetMidX(rect) / 2 + 10;
            y03 = CGRectGetHeight(rect) - 10;
            break;
        }
        case RBMenuArrowDirectionLeft:
        {
            x01 = 0;
            y01 = CGRectGetMidY(rect);
            x02 = 10;
            y02 = CGRectGetMidY(rect) - 10;
            x03 = 10;
            y03 = CGRectGetMidY(rect) + 10;
            break;
        }
        case RBMenuArrowDirectionRight:
        {
            x01 = CGRectGetWidth(rect);
            y01 = CGRectGetMidY(rect);
            x02 = CGRectGetWidth(rect) - 10;
            y02 = CGRectGetMidY(rect) - 10;
            x03 = CGRectGetWidth(rect) - 10;
            y03 = CGRectGetMidY(rect) + 10;
            break;
        }
        case RBMenuArrowDirectionDown:
        {
            x01 = CGRectGetMidX(rect);
            y01 = CGRectGetHeight(rect);
            x02 = CGRectGetMidX(rect) - 10;
            y02 = CGRectGetHeight(rect) - 10;
            x03 = CGRectGetMidX(rect) + 10;
            y03 = CGRectGetHeight(rect) - 10;
            break;
        }
        case RBMenuArrowDirectionNone:
        case RBMenuArrowDirectionUp:
        {
            x01 = CGRectGetMidX(rect);
            y01 = 0;
            x02 = CGRectGetMidX(rect) - 10;
            y02 = 10;
            x03 = CGRectGetMidX(rect) + 10;
            y03 = 10;
            break;
        }
            
        default:
            break;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, x01, y01); //顶点
    CGContextAddLineToPoint(ctx, x02, y02);
    CGContextAddLineToPoint(ctx, x03, y03);
    
    CGContextClosePath(ctx);
    CGContextSetFillColorWithColor(ctx, _gTintColor.CGColor);
    
    CGContextFillPath(ctx);
}

- (void)drawBackground:(CGRect)rect
{
    CGFloat width = rect.size.width - 20;
    CGFloat height = rect.size.height - 20;
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
    CGFloat radius = 4;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    // 移动到初始点
    CGPathMoveToPoint(path, nil, radius + 10, 0 + 10);
    
    // 绘制第1条线和第1个1/4圆弧，右上
    CGPathAddLineToPoint(path, 0, width - radius, 10);
    CGPathAddArc(path, nil, width - radius + 10, radius + 10, radius, -0.5 * M_PI, 0.0, 0);
    
    // 绘制第2条线和第2个1/4圆弧，右下
    CGPathAddLineToPoint(path, 0, width + 10, height - radius + 10);
    CGPathAddArc(path, nil, width - radius + 10, height - radius + 10, radius, 0.0, 0.5 * M_PI, 0);
    
    // 绘制第3条线和第3个1/4圆弧，左下
    CGPathAddLineToPoint(path, 0, radius, height + 10);
    CGPathAddArc(path, nil, radius + 10, height - radius + 10, radius, 0.5 * M_PI, M_PI, 0);
    
    // 绘制第4条线和第4个1/4圆弧，左上
    CGPathAddLineToPoint(path, 0, 0 + 10, radius + 10);
    CGPathAddArc(path, nil, radius + 10, radius + 10 , radius, M_PI, 1.5 * M_PI, 0);
    
    // 闭合路径
    CGContextAddPath(context, path);
    // 填充半透明黑色
//    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.8);
    CGContextSetFillColorWithColor(context, _gTintColor.CGColor);
   //执行绘画
    CGContextDrawPath(context, kCGPathFill);
    
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.path = path;
//    self.layer.mask = layer;
}

- (void)drawLine:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (NSInteger i=1; i<ITEMS; i++) {
        [path moveToPoint:CGPointMake(10 , ITEM_HEIGHT * i + 10)];
        [path addLineToPoint:CGPointMake(ITEM_WIDTH + 10, ITEM_HEIGHT * i + 10)];
        [_lineColor setStroke];
        // 将path绘制出来
        [path stroke];
    }
}

- (void)drawItems
{
    for (NSInteger i=0; i<ITEMS; i++) {
        RBMenuItem *item = self.items[i];
        UIImage *iconImg = item.image;
        UIImage *iconTouchImg = item.hltImage;
        NSString *title = item.title;
        
        if (iconImg == nil && iconTouchImg == nil && title == nil) {
            continue ;
        }
        
        CGFloat imgXY = 20;
        CGFloat titleX = 40;
        CGFloat padding = 5;
        if (iconImg == nil && iconTouchImg == nil) {
            titleX = 20;
            padding = 0;
        }
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = item.titleAlignment;
        paragraphStyle.lineSpacing = 5;
        NSDictionary *attribute = nil;
        
        if (i == self.touchIndex) {
            [iconTouchImg drawInRect:CGRectMake(imgXY, ITEM_HEIGHT * i + 20, imgXY, imgXY)];
            attribute = @{
                          NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                          NSForegroundColorAttributeName:self.titleHltColor,
                          NSParagraphStyleAttributeName:paragraphStyle
                          };
        } else {
            [iconImg drawInRect:CGRectMake(imgXY, ITEM_HEIGHT * i + 20, imgXY, imgXY)];
            attribute = @{
                          NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                          NSForegroundColorAttributeName:self.titleTintColor,
                          NSParagraphStyleAttributeName:paragraphStyle
                          };
        }
        
        if (title != nil) {
            [title drawInRect:CGRectMake(titleX + padding, ITEM_HEIGHT * i + 20, ITEM_WIDTH - titleX - padding, ITEM_HEIGHT)
                    withAttributes:attribute];
        }
    }
}

#pragma mark -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point  = [touch locationInView:self];
    
    for (int i = 0 ; i < ITEMS; i++) {
        if (CGRectContainsPoint(CGRectMake(10, ITEM_HEIGHT * i + 10, ITEM_WIDTH, ITEM_HEIGHT), point)) {
            self.touchIndex = i;
            [self setNeedsDisplay];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.touchIndex = -1;
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point  = [touch locationInView:self];
    
    if (self.onTouchBlock) {
        if (CGRectContainsPoint(CGRectMake(10, 10, ITEM_WIDTH, ITEM_HEIGHT * ITEMS), point)) {
            RBMenuItem *item = self.items[self.touchIndex];
            self.onTouchBlock(self.touchIndex, item.title);
        }
    }
    [self dismiss];
    self.touchIndex = -1;
}

#pragma mark -

- (void)showMenuInView:(UIView *)view
              fromRect:(CGRect)rect
             menuItems:(NSArray *)menuItems;
{
    RBMenuOverlay *overlay = [[RBMenuOverlay alloc] initWithFrame:view.bounds];

    self.items = menuItems;
    self.touchIndex = -1;
    [self setNeedsDisplay];
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    ITEMS = menuItems.count;
    
    self.arrowDirection = [self configTheArrowDirection:rect];
    self.relateRect = rect;
    rect = [self configTheRect:rect];
    
    self.frame = rect;
    self.alpha = 0;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 1.0f;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationWillChange:)
                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)dismiss
{
    RBMenuView *menu = self;
    RBMenuOverlay *overlay = (RBMenuOverlay *)menu.superview;
    if (!overlay) {
        return ;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
    [UIView animateWithDuration:0.2f animations:^{
        menu.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [menu removeFromSuperview];
        [overlay removeFromSuperview];
    }];
}

- (void)orientationWillChange:(NSNotification *)notification
{
    [self dismiss];
}

#pragma mark config

- (RBMenuArrowDirection)configTheArrowDirection:(CGRect)rect
{
    CGPoint point = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    CGRect mainArea = [[UIScreen mainScreen] bounds];
    CGFloat equalityW = CGRectGetWidth(mainArea) / 3;
    CGFloat equalityH = CGRectGetHeight(mainArea) / 3;
    
    CGRect upLeftArea = CGRectMake(0, 0, equalityW, equalityH);
    CGRect upCenterArea = CGRectMake(equalityW, 0, equalityW, equalityH);
    CGRect upRightArea = CGRectMake(equalityW * 2, 0, equalityW, equalityH);
    
    CGRect centerLeftArea = CGRectMake(0, equalityH, equalityW, equalityH);
    CGRect centerArea = CGRectMake(equalityW, equalityH, equalityW, equalityH);
    CGRect centerRightArea = CGRectMake(equalityW * 2, equalityH, equalityW, equalityH);
    
    CGRect downLeftArea = CGRectMake(0, equalityH * 2, equalityW, equalityH);
    CGRect downCeterArea = CGRectMake(equalityW, equalityH * 2, equalityW, equalityH);
    CGRect downRightArea = CGRectMake(equalityW * 2, equalityH * 2, equalityW, equalityH);
    
    RBMenuArrowDirection arrowDirection = RBMenuArrowDirectionNone;
    
    if (CGRectContainsPoint(upLeftArea, point)) {
        arrowDirection = RBMenuArrowDirectionUpLeft;
    }
    if (CGRectContainsPoint(upCenterArea, point)) {
        arrowDirection = RBMenuArrowDirectionUp;
    }
    if (CGRectContainsPoint(upRightArea, point)) {
        arrowDirection = RBMenuArrowDirectionUpRight;
    }
    
    if (CGRectContainsPoint(centerLeftArea, point)) {
        arrowDirection = RBMenuArrowDirectionLeft;
    }
    if (CGRectContainsPoint(centerArea, point)) {
        if (CGRectContainsPoint(UIEdgeInsetsInsetRect(centerArea, UIEdgeInsetsMake(0, 0, equalityH / 2, 0)), point)) {
            arrowDirection = RBMenuArrowDirectionUp;
        } else {
            arrowDirection = RBMenuArrowDirectionDown;
        }
    }
    if (CGRectContainsPoint(centerRightArea, point)) {
        arrowDirection = RBMenuArrowDirectionRight;
    }
    
    if (CGRectContainsPoint(downLeftArea, point)) {
        arrowDirection = RBMenuArrowDirectionDownLeft;
    }
    if (CGRectContainsPoint(downCeterArea, point)) {
        arrowDirection = RBMenuArrowDirectionDown;
    }
    if (CGRectContainsPoint(downRightArea, point)) {
        arrowDirection = RBMenuArrowDirectionDownRight;
    }
    
    return arrowDirection;
}

- (CGRect)configTheRect:(CGRect)rect
{
    switch (_arrowDirection) {
        case RBMenuArrowDirectionUpLeft:
            rect.origin.x = CGRectGetMinX(rect);
            rect.origin.y = CGRectGetMaxY(rect);
            break;
        case RBMenuArrowDirectionUpRight:
            rect.origin.x = CGRectGetMinX(rect) - ITEM_WIDTH / 2 - 10;
            rect.origin.y = CGRectGetMaxY(rect);
            break;
        case RBMenuArrowDirectionDownLeft:
            rect.origin.x = CGRectGetMinX(rect);
            rect.origin.y = CGRectGetMinY(rect) - ITEM_HEIGHT * ITEMS - 20;
            break;
        case RBMenuArrowDirectionDownRight:
            rect.origin.x = CGRectGetMinX(rect) - ITEM_WIDTH / 2 - 10;
            rect.origin.y = CGRectGetMinY(rect) - ITEM_HEIGHT * ITEMS - 20;
            break;
        case RBMenuArrowDirectionLeft:
            rect.origin.x = CGRectGetMaxX(rect);
            rect.origin.y = CGRectGetMidY(rect) - ITEM_HEIGHT * ITEMS / 2 - 10;
            break;
        case RBMenuArrowDirectionRight:
            rect.origin.x = CGRectGetMinX(rect) - ITEM_WIDTH - 20;
            rect.origin.y = CGRectGetMidY(rect) - ITEM_HEIGHT * ITEMS / 2 - 10;
            break;
        case RBMenuArrowDirectionDown:
            rect.origin.x = CGRectGetMidX(rect) - ITEM_WIDTH / 2 - 10;
            rect.origin.y = CGRectGetMinY(rect) - ITEM_HEIGHT * ITEMS - 20;
            break;
        case RBMenuArrowDirectionNone:
        case RBMenuArrowDirectionUp:
            rect.origin.x = CGRectGetMidX(rect) - ITEM_WIDTH / 2 - 10;
            rect.origin.y = CGRectGetMaxY(rect);
            break;
            
        default:
            break;
    }

    rect.size.width = ITEM_WIDTH + 20;
    rect.size.height = ITEM_HEIGHT * ITEMS + 20;
    return rect;
}


@end

#pragma mark - RBMenu

@implementation RBMenu

+ (void)showMenuInView:(UIView *)view
            fromRect:(CGRect)rect
            menuItems:(NSArray *)menuItems
{
    if (menuItems.count == 0) {
        return ;
    }
    [[RBMenuView shareMenu] showMenuInView:view fromRect:rect menuItems:menuItems];
}

+ (void)dismissMenu
{
    RBMenuView *menuView = [RBMenuView shareMenu];
    [menuView dismiss];
}

+ (void)setTintColor:(UIColor *) tintColor
{
    RBMenuView *menuView = [RBMenuView shareMenu];
    if (!menuView.superview) {
        return ;
    }
    menuView.gTintColor = tintColor;
}

+ (void)setLineColor:(UIColor *)lineColor
{
    RBMenuView *menuView = [RBMenuView shareMenu];
    if (!menuView.superview) {
        return ;
    }
    menuView.lineColor = lineColor;
}

+ (void)setTitleTintColor:(UIColor *)titleTintColor
{
    RBMenuView *menuView = [RBMenuView shareMenu];
    if (!menuView.superview) {
        return ;
    }
    menuView.titleTintColor = titleTintColor;
}

+ (void)setTitleHltColor:(UIColor *)titleHltColor
{
    RBMenuView *menuView = [RBMenuView shareMenu];
    if (!menuView.superview) {
        return ;
    }
    menuView.titleHltColor = titleHltColor;
}


+ (void) makeOnTouchBlock:(OnTouchBlock) onTouchBlock
{
    RBMenuView *menuView = [RBMenuView shareMenu];
    if (!menuView.superview) {
        return ;
    }
    if (onTouchBlock) {
        [menuView setOnTouchBlock:onTouchBlock];
    }
}

+ (void)setMenuWidth:(CGFloat)width
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width / 2;
    if (width <= screenW && width > ITEM_WIDTH) {
        ITEM_WIDTH = width;
        RBMenuView *menuView = [RBMenuView shareMenu];
        CGRect frame = menuView.frame;
        frame = [menuView configTheRect:menuView.relateRect];
        menuView.frame = frame;
    }
}


@end
