//
//  CircleLineButton.h
//  Pods
//
//  Created by Samuel Yam on 3/10/17.
//
//

#import <UIKit/UIKit.h>
@interface CircleLineButton : UIButton

@property (nonatomic, strong, readonly) UIColor *color;

- (void)drawCircleButton:(UIColor *)color withStroke:(UIColor *)strokeColor;

@end
