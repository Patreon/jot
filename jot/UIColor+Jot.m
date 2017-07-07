//
//  UIColor+Jot.m
//  Pods
//
//  Created by Ted Lee on 6/29/17.
//
//

#import "UIColor+Jot.h"

#define UIColorFromRGB(rgbValue)   [UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue : ((float)(rgbValue & 0xFF)) / 255.0 alpha : 1.0]
#define UIColorFromRGBA(rgbaValue) [UIColor colorWithRed : ((float)((rgbaValue & 0xFF000000) >> 24)) / 255.0 green : ((float)((rgbaValue & 0xFF0000) >> 16)) / 255.0 blue : ((float)((rgbaValue & 0xFF00) >> 8)) / 255.0 alpha : ((float)(rgbaValue & 0xFF)) / 255.0]

@implementation UIColor (Jot)

+ (UIColor *)jotBlack {
    return UIColorFromRGB(0x4A4A4A);
}

+ (UIColor *)jotBlue {
    return UIColorFromRGB(0x4A90E2);
}

+ (UIColor *)jotGreen {
    return UIColorFromRGB(0x7ED321);
}

+ (UIColor *)jotYellow {
    return UIColorFromRGB(0xF8E81C);
}

+ (UIColor *)jotCoral {
    return UIColorFromRGB(0xF5A623);
}

+ (UIColor *)jotPurple {
    return UIColorFromRGB(0xBD10E0);
}

@end
