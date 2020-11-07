//
//  UIImageViewEx.h
//  TKit
//
//  Created by bill on 12-12-21.
//  Copyright (c) 2012年 _Mac. All rights reserved.
//

@interface UIImageView (Ext)

+ (id)newImgView:(CGRect)frame;
+ (id)newImgViewByImg:(UIImage *)image;

/// self.image=image,self.size=image.size
@property (nonatomic, strong) UIImage *imageEx;

/// self.image=image,self.size=scaleToWidth,scaleToWidth/(image.width/image.height)
-(void) dosetImage:(UIImage*)image scaleToWidth:(float)scaleToWidth;

@end