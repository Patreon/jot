//
//  TextAlignmentButton.m
//  Pods
//
//  Created by Ted Lee on 7/6/17.
//
//

#import "TextAlignmentButton.h"

@interface TextAlignmentButton ()

@property (nonatomic, strong) NSBundle *bundle;

@end

@implementation TextAlignmentButton

- (id)init {
    self = [super init];
    if (self) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:@"jot" withExtension:@"bundle"];
        self.bundle = [NSBundle bundleWithURL:url];

        self.textAlignment = JOTTextAlignmentCenter;
        [self updateButton];
    }
    return self;
}

- (void)switchToNextTextAlignment {
    switch (self.textAlignment) {
        case JOTTextAlignmentCenter:
            self.textAlignment = JOTTextAlignmentRight;
            break;
            
        case JOTTextAlignmentRight:
            self.textAlignment = JOTTextAlignmentLeft;
            break;
            
        case JOTTextAlignmentLeft:
            self.textAlignment = JOTTextAlignmentCenter;
            break;
            
        default:
            break;
    }
    
    [self updateButton];
}

- (void)updateButton {

    
    switch (self.textAlignment) {
        case JOTTextAlignmentCenter:
            [self setBackgroundImage:[UIImage imageNamed:@"center" inBundle:self.bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            break;
            
        case JOTTextAlignmentRight:
            [self setBackgroundImage:[UIImage imageNamed:@"right" inBundle:self.bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            break;
            
        case JOTTextAlignmentLeft:
            [self setBackgroundImage:[UIImage imageNamed:@"left" inBundle:self.bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

@end
