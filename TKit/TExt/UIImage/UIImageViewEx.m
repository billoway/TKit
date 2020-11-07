//
//  UIImageViewEx.m
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

#import "UIImageViewEx.h"
#import "TExt.h"

@implementation UIImageView (TExt)

+ (id)newImgView:(CGRect)frame;
{
    id tImgView = nil;
    
    tImgView = [[[self class] alloc] init];
    [tImgView setFrame:frame];
    return tImgView;
}

+ (id)newImgViewByImg:(UIImage *)image;
{
    if (image && ![image isKindOfClass:[UIImage class]]) {
        image = nil;
    }
    
    id tImgView = [self newImgView:CGRectMake(0, 0, image.width, image.height)];
    [tImgView setImage:image];
    return tImgView;
}

/// self.image=image,self.size=image.size
- (void)setImageEx:(UIImage *)image
{
    self.image = image;
    self.size = CGSizeMake(image.width, image.height);
}

/// self.image=image,self.size=scaleToWidth,scaleToWidth/(image.width/image.height)
-(void) dosetImage:(UIImage*)image scaleToWidth:(float)scaleToWidth;
{
    self.imageEx = image;
    
    if (scaleToWidth>0 && image && [image isKindOfClass:[UIImage class]]) {
        self.size = CGSizeMake(scaleToWidth,scaleToWidth/(image.width/image.height));
    }
}


@end