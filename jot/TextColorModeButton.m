//
//  TextColorModeButton.m
//  Pods
//
//  Created by Ted Lee on 6/28/17.
//
//

#import "TextColorModeButton.h"

@interface TextColorModeButton ()

@property (nonatomic, strong) NSBundle *bundle;

@end

@implementation TextColorModeButton

- (id)init {
    self = [super init];
    if (self) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:@"jot" withExtension:@"bundle"];
        self.bundle = [NSBundle bundleWithURL:url];
        
        self.colorMode = JOTTextColorModeOpaqueBackground;
        [self updateButton];
    }
    return self;
}



- (void)switchToNextColorMode {
    switch (self.colorMode) {
        case JOTTextColorModeOpaqueBackground:
            self.colorMode = JOTTextColorModeTransparentBackground;
            break;
            
        case JOTTextColorModeTransparentBackground:
            self.colorMode = JOTTextColorModeClearBackground;
            break;
            
        case JOTTextColorModeClearBackground:
            self.colorMode = JOTTextColorModeOpaqueBackground;
            break;
            
        default:
            break;
    }
    
    [self updateButton];

}

- (void)updateButton {
    
    switch (self.colorMode) {
        case JOTTextColorModeOpaqueBackground:
            [self setBackgroundImage:[UIImage imageNamed:@"background-style-opaque" inBundle:self.bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            break;
            
        case JOTTextColorModeTransparentBackground:
            [self setBackgroundImage:[UIImage imageNamed:@"background-style-50-opacity" inBundle:self.bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            break;
            
        case JOTTextColorModeClearBackground:
            [self setBackgroundImage:[UIImage imageNamed:@"background-style-none" inBundle:self.bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


@end
