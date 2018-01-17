//
//  TextColorModeButton.m
//  Pods
//
//  Created by Ted Lee on 6/28/17.
//
//

#import "TextColorModeButton.h"

@interface TextColorModeButton ()

@end

@implementation TextColorModeButton

- (id)init {
    self = [super init];
    if (self) {
        
        self.colorMode = JOTTextColorModeOpaqueBackground;
        
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
        [self setTitle:@"A" forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor whiteColor];
        self.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 3;
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
            [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.backgroundColor = [UIColor whiteColor];
            break;
            
        case JOTTextColorModeTransparentBackground:
            self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.5];
            self.layer.borderWidth = 0;
            break;
            
        case JOTTextColorModeClearBackground:
            self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.0];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.layer.borderWidth = 3;
            break;
            
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    

}


@end
