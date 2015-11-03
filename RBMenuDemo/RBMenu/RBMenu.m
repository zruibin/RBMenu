//
//  RBMenu.m
//  AnimationDemo
//
//  Created by  zruibin on 15/11/3.
//  Copyright © 2015年 RBCHOW. All rights reserved.
//

#import "RBMenu.h"

#pragma mark - RBMenuItem

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
        if ([v isKindOfClass:[RBMenu class]]) {
            
            CGPoint pt = [recognizer locationInView:self];
            UIView *view = [self hitTest:pt withEvent:nil];
            if (view != v) {
                [RBMenu dismissMenu];
            }
        }
    }
}

@end


#pragma mark - RBMenu

@interface RBMenu ()

@property (nonatomic, assign) RBMenuArrowDirection arrowDirection;
@property (nonatomic, assign) NSInteger touchIndex;
@property (nonatomic, strong) UIColor *gTintColor;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *titleTintColor;
@property (nonatomic, strong) UIColor *titleHltColor;
@property (nonatomic, assign) NSTextAlignment titleAlignment;
@property (nonatomic, strong) NSArray *items;

- (void) dismiss;
- (CGRect)configTheRect:(CGRect)rect;

@end



static const CGFloat ITEM_WIDTH = 120.0f;
static const CGFloat ITEM_HEIGHT = 40.0f;
static NSInteger ITEMS = 0;

@implementation RBMenu

+ (RBMenu *)shareMenu
{
    static RBMenu *menu;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menu = [[RBMenu alloc] init];
        menu.backgroundColor = [UIColor clearColor];
        menu.gTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        menu.lineColor =  [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4];
        menu.titleTintColor = [UIColor whiteColor];
        menu.titleHltColor = [UIColor orangeColor];
    });
    return menu;
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
        if (iconImg == nil || iconTouchImg == nil) {
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
//    UITouch *touch = [touches anyObject];
//    CGPoint point  = [touch locationInView:self];
    
    self.touchIndex = -1;
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
//    UITouch *touch = [touches anyObject];
//    CGPoint point  = [touch locationInView:self];
    
    if (self.onTouchBlock) {
        RBMenuItem *item = self.items[self.touchIndex];
        self.onTouchBlock(self.touchIndex, item.title);
    }
    [self dismiss];
    self.touchIndex = -1;
    
    
}

#pragma mark -

- (void)dismiss
{
    RBMenu *menu = self;
    RBMenuOverlay *overlay = (RBMenuOverlay *)menu.superview;
    if (!overlay) {
        return ;
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        menu.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [menu removeFromSuperview];
        [overlay removeFromSuperview];
    }];
}

- (CGRect)configTheRect:(CGRect)rect
{
    switch (_arrowDirection) {
        case RBMenuArrowDirectionUpLeft:
            rect.origin.x = CGRectGetMinX(rect);
            rect.origin.y = CGRectGetMaxY(rect);
            break;
        case RBMenuArrowDirectionUpRight:
            rect.origin.x = CGRectGetMinX(rect) - ITEM_WIDTH / 2;
            rect.origin.y = CGRectGetMaxY(rect);
            break;
        case RBMenuArrowDirectionDownLeft:
            rect.origin.x = CGRectGetMinX(rect);
            rect.origin.y = CGRectGetMinY(rect) - ITEM_HEIGHT * ITEMS - 20;
            break;
        case RBMenuArrowDirectionDownRight:
            rect.origin.x = CGRectGetMinX(rect) - ITEM_WIDTH / 2;
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
        case RBMenuArrowDirectionUp:
            rect.origin.x = CGRectGetMidX(rect) - ITEM_WIDTH / 2 - 10;
            rect.origin.y = CGRectGetMaxY(rect);
            break;
        case RBMenuArrowDirectionDown:
            rect.origin.x = CGRectGetMidX(rect) - ITEM_WIDTH / 2 - 10;
            rect.origin.y = CGRectGetMinY(rect) - ITEM_HEIGHT * ITEMS - 20;
            break;
            
        default:
            break;
    }

    
    return rect;
}


#pragma mark -

+ (void) showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems arrowDirection:(RBMenuArrowDirection)arrowDirection
{
    if (menuItems.count == 0) {
        return ;
    }
    RBMenuOverlay *overlay = [[RBMenuOverlay alloc] initWithFrame:view.bounds];
    RBMenu *menu = [self shareMenu];
    menu.items = menuItems;
    menu.touchIndex = -1;
    [menu setNeedsDisplay];
    [overlay addSubview:menu];
    [view addSubview:overlay];
   
    ITEMS = menuItems.count;
    
    menu.arrowDirection = arrowDirection;
    rect = [menu configTheRect:rect];
    
    rect.size.width = ITEM_WIDTH + 20;
    rect.size.height = ITEM_HEIGHT * ITEMS + 20;
    
    menu.frame = rect;
    menu.alpha = 0;

    [UIView animateWithDuration:0.2f animations:^{
        menu.alpha = 1.0f;
    }];
    
}

+ (void) dismissMenu
{
    RBMenu *menu = [self shareMenu];
    [menu dismiss];
}

+ (void) setTintColor:(UIColor *) tintColor
{
    RBMenu *menu = [self shareMenu];
    if (!menu.superview) {
        return ;
    }
    menu.gTintColor = tintColor;
}

+ (void) setLineColor:(UIColor *)lineColor
{
    RBMenu *menu = [self shareMenu];
    if (!menu.superview) {
        return ;
    }
    menu.lineColor = lineColor;
}

+ (void)setTitleTintColor:(UIColor *)titleTintColor
{
    RBMenu *menu = [self shareMenu];
    if (!menu.superview) {
        return ;
    }
    menu.titleTintColor = titleTintColor;
}

+ (void)setTitleHltColor:(UIColor *)titleHltColor
{
    RBMenu *menu = [self shareMenu];
    if (!menu.superview) {
        return ;
    }
    menu.titleHltColor = titleHltColor;
}


+ (void) makeOnTouchBlock:(OnTouchBlock) onTouchBlock
{
    RBMenu *menu = [self shareMenu];
    if (!menu.superview) {
        return ;
    }
    if (onTouchBlock) {
        [menu setOnTouchBlock:onTouchBlock];
    }
}


@end








