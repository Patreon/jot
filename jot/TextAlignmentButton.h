//
//  TextAlignmentButton.h
//  Pods
//
//  Created by Ted Lee on 7/6/17.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JOTTextAlignment) {
    JOTTextAlignmentLeft,
    JOTTextAlignmentCenter,
    JOTTextAlignmentRight
};


@interface TextAlignmentButton : UIButton

@property (nonatomic, assign) JOTTextAlignment textAlignment;

- (void) switchToNextTextAlignment;

@end
