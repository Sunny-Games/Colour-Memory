//
//  DJFont.m
//  DejaFashion
//
//  Created by Kevin Lin on 18/11/14.
//  Copyright (c) 2014 Mozat. All rights reserved.
//

#import "UIFont+Custom.h"
 
@implementation UIFont (Custom)

+(UIFont *)helveticaFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+(UIFont *)lightHelveticaFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:size];
}

+(UIFont *)boldHelveticaFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

+(UIFont *)mediumHelveticaFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+(UIFont *)condensedHelveticaFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:size];
}

+ (UIFont *)thinHelveticaFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
}

+(UIFont *)tutorialFont:(CGFloat)size {
    return [UIFont fontWithName:@"SegoePrint" size:size];
}

+ (UIFont *)regularFont:(CGFloat)size
{
    return [UIFont helveticaFontOfSize:size];
}

+ (UIFont *)lightfont:(CGFloat)size{
    return [UIFont lightHelveticaFontOfSize:size];
}

+ (UIFont *)mediumfont:(CGFloat)size{
    return [UIFont mediumHelveticaFontOfSize:size];
}

+ (UIFont *)boldFont:(CGFloat)size
{
    return [UIFont boldHelveticaFontOfSize:size];
}


+ (UIFont *)lightItalicFont:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:size];
}

+ (UIFont *)boldItalicFont:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:size];
}

+ (UIFont *)italicFont:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Italic" size:size];
}


@end
