//
//  UIViewEx.m
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "UIViewEx.h"
#import "UIDeviceEx.h"

@implementation UIView (TExt)

+ (id)newView:(CGRect)frame
{
    return [self newView:frame bgColor:[UIColor clearColor]];
}

+ (id)newView:(CGRect)frame bgColor:(UIColor *)bgColor
{
    id tView = [[[self class] alloc] initWithFrame:frame];
    [tView setBackgroundColor:bgColor];
    return tView;
}

+ (id)newViewByXibName:(NSString *)xibName owner:(id)owner options:(NSDictionary *)options;
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:xibName owner:owner options:options];
    //得到第一个UIView
    id xibView = [nib objectAtIndex:0];
    return xibView;
}

- (id)muCopy
{
    if ([self respondsToSelector:@selector(setText:)]) {
        NSString *text = [self performSelector:@selector(text)];
        
        if (!text || [text isEqualToString:@""]) {
            [self performSelector:@selector(setText:) withObject:@""];
        }
    }
    
    NSData  *tArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    UIView  *cpView = [NSKeyedUnarchiver unarchiveObjectWithData:tArchive];
    return cpView;
}

- (id)muCopy:(CGRect)frame
{
    id cpView = [self muCopy];
    [cpView setFrame:frame];
    return cpView;
}

#pragma mark - -------- view frame ----------

- (CGFloat)left
{
    return k_float_int(self.frame.origin.x);
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    
    frame.origin.x = k_float_int(x);
    self.frame = frame;
}

- (CGFloat)right
{
    return k_float_int(self.frame.origin.x + self.frame.size.width);
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    
    frame.origin.x = k_float_int(right - frame.size.width);
    self.frame = frame;
}

- (CGFloat)top
{
    return k_float_int(self.frame.origin.y);
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    
    frame.origin.y = k_float_int(y);
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    
    frame.origin.y = k_float_int(bottom - frame.size.height);
    self.frame = frame;
}

- (CGFloat)width
{
    return k_float_int(self.frame.size.width);
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    
    frame.size.width = k_float_int(width);
    self.frame = frame;
}

- (CGFloat)height
{
    return k_float_int(self.frame.size.height);
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    
    frame.size.height = k_float_int(height);
    self.frame = frame;
}

- (CGSize)size
{
    return CGSizeMake( k_float_int(self.frame.size.width), k_float_int(self.frame.size.height) );
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    
    frame.size.height = k_float_int(size.height);
    frame.size.width = k_float_int(size.width);
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    
    frame.origin.x = k_float_int(origin.x);
    frame.origin.y = k_float_int(origin.y);
    self.frame = frame;
}

#pragma mark - -------- view background ----------

/// view 的背景图片 图片填充做颜色
- (void)setBackImage:(UIImage *)backImage
{
    [self setBackgroundColor:[UIColor colorWithPatternImage:backImage]];
}

- (void)setCornerRadius:(CGFloat)radius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

- (void)setBorderWidth:(CGFloat)width coror:(UIColor *)color
{
    self.layer.borderWidth = width;
    self.layer.borderColor = [color CGColor];
}

- (void)setShadowCoror:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius
{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
}

#pragma mark - -------- view subviews ----------

- (BOOL)containsSubView:(UIView *)subView
{
    for (UIView *view in[self subviews]) {
        if ([view isEqual:subView]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)containsSubViewOfClassType:(Class)tClass
{
    for (UIView *view in[self subviews]) {
        if ([view isMemberOfClass:tClass]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSInteger)getSubviewIndex
{
    return [self.superview.subviews indexOfObject:self];
}

- (void)bringToFront
{
    [self.superview bringSubviewToFront:self];
}

- (void)sendToBack
{
    [self.superview sendSubviewToBack:self];
}

- (void)bringOneLevelUp
{
    NSInteger currentIndex = [self getSubviewIndex];
    
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex + 1];
}

- (void)sendOneLevelDown
{
    NSInteger currentIndex = [self getSubviewIndex];
    
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex - 1];
}

- (BOOL)isInFront
{
    return [self.superview.subviews lastObject] == self;
}

- (BOOL)isAtBack
{
    return [self.superview.subviews objectAtIndex:0] == self;
}

- (void)swapDepthsWithView:(UIView *)swapView
{
    [self.superview exchangeSubviewAtIndex:[self getSubviewIndex] withSubviewAtIndex:[swapView getSubviewIndex]];
}

- (void)removeSubviews
{
    for (UIView *tV in self.subviews) {
        [tV removeFromSuperview];
    }
}

@end