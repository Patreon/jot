//
//  CircleLineButton.m
//  Pods
//
//  Created by Samuel Yam on 3/10/17.
//
//

#import "CircleLineButton.h"

@interface CircleLineButton ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) UIColor *color;
@end

@implementation CircleLineButton

- (void)drawCircleButton:(UIColor *)color withStroke:(UIColor *)strokeColor
{
  self.color = color;
  [self setTitleColor:color forState:UIControlStateNormal];
  self.circleLayer = [CAShapeLayer layer];
  [self.circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self bounds].size.width,
                                         [self bounds].size.height)];
  [self.circleLayer setPosition:CGPointMake(CGRectGetMidX([self bounds]),CGRectGetMidY([self bounds]))];
  UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
  [self.circleLayer setPath:[path CGPath]];
  [self.circleLayer setStrokeColor:[strokeColor CGColor]];
  [self.circleLayer setLineWidth:2.0f];
  [self.circleLayer setFillColor:[color CGColor]];
  
  [[self layer] addSublayer:self.circleLayer];
}

- (void)setHighlighted:(BOOL)highlighted
{
  if (highlighted)
  {
    self.transform = CGAffineTransformMakeScale(.8, .8);
  }
  else
  {
    [UIView animateWithDuration:0.05 animations:^{self.transform = CGAffineTransformMakeScale(1.0, 1.0);}];
  }
}

@end
