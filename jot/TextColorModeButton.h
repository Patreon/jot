//
//  TextColorModeButton.h
//  Pods
//
//  Created by Ted Lee on 6/28/17.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JOTTextColorMode) {
    JOTTextColorModeOpaqueBackground,
    JOTTextColorModeTransparentBackground,
    // With this setting we change the fonts color instead of the views background color
    JOTTextColorModeClearBackground
};

@interface TextColorModeButton : UIButton

@property (nonatomic, assign) JOTTextColorMode colorMode;

- (void)switchToNextColorMode;

@end
