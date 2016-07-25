//
//  DJFont.h
//  DejaFashion
//
//  Created by Kevin Lin on 18/11/14.
//  Copyright (c) 2014 Mozat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Custom)

+ (UIFont *)regularFont:(CGFloat)size;
+ (UIFont *)lightfont:(CGFloat)size;
+ (UIFont *)mediumfont:(CGFloat)size;
+ (UIFont *)boldFont:(CGFloat)size;

+ (UIFont *)italicFont:(CGFloat)size;
+ (UIFont *)lightItalicFont:(CGFloat)size;
+ (UIFont *)boldItalicFont:(CGFloat)size;

+ (UIFont *)tutorialFont: (CGFloat)size;
@end
