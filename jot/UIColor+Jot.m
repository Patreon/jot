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

+ (UIColor *)jotNavy {
    return UIColorFromRGB(0x052D49);
}

+ (UIColor *)jotBlue {
    return UIColorFromRGB(0x358EFF);
}

+ (UIColor *)jotGreen {
    return UIColorFromRGB(0x63D6A3);
}

+ (UIColor *)jotTurquoise {
    return UIColorFromRGB(0x006375);
}

+ (UIColor *)jotCoral {
    return UIColorFromRGB(0xF96854);
}

+ (UIColor *)jotSalmon {
    return UIColorFromRGB(0xFF9B7A);
}

@end
