//
//  JotTextEditView.m
//  jot
//
//  Created by Laura Skelton on 4/30/15.
//
//

#import "JotTextEditView.h"
#import "CircleLineButton.h"
#import "TextColorModeButton.h"
#import "TextAlignmentButton.h"
#import <Masonry/Masonry.h>

#import "UIColor+Jot.h"

static const NSUInteger kCharacterLimit = 140;

@interface JotTextEditView () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *textContainer;
@property (nonatomic, strong) CAGradientLayer *gradientMask;
@property (nonatomic, strong) CAGradientLayer *topGradient;
@property (nonatomic, strong) CAGradientLayer *bottomGradient;
@property (nonatomic, strong) UIButton *trashcanButton;
@property (nonatomic, strong) UIButton *textAnnotationDoneButton;
@property (nonatomic, strong) TextAlignmentButton *textAlignmentButton;
@property (nonatomic, strong) TextColorModeButton *backgroundColorModeButton;

@end

@implementation JotTextEditView

- (instancetype)init
{
    if ((self = [super init])) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _font = [UIFont systemFontOfSize:40.f];
        _fontSize = 40.f;
        
        _textEditingInsets = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
        
        _textContainer = [UIView new];
        self.textContainer.layer.masksToBounds = YES;
        [self addSubview:self.textContainer];
        [self.textContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.right.equalTo(self);
            make.bottom.equalTo(self).offset(0.f);
        }];
        
        self.backgroundColor = [UIColor whiteColor];
      
        _textView = [UITextView new];
        self.textView.backgroundColor = self.backgroundColor;
        self.textColor = [UIColor patreonNavy];
        self.textView.text = self.textString;
        self.textView.keyboardType = UIKeyboardTypeDefault;
        self.textView.returnKeyType = UIReturnKeyDone;
        self.textView.clipsToBounds = NO;
        self.textView.scrollEnabled = NO;
        self.textView.delegate = self;
        self.textView.layer.cornerRadius = 5;
        [self.textContainer addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            //make.centerY.equalTo(self.mas_centerY);
            make.width.mas_lessThanOrEqualTo(self.mas_width);
        }];
        
        self.textContainer.hidden = YES;
        self.userInteractionEnabled = NO;
      
        UIToolbar *colorSelector = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.textView.frame.size.width, 80)];
        [colorSelector setBackgroundImage:[UIImage new]
                    forToolbarPosition:UIBarPositionAny
                            barMetrics:UIBarMetricsDefault];
        [colorSelector setShadowImage:[UIImage new]
                forToolbarPosition:UIBarPositionAny];
      
        NSArray *colors = @[[UIColor whiteColor], [UIColor patreonNavy], [UIColor patreonBlue], [UIColor patreonGreen], [UIColor patreonTurquoise], [UIColor patreonSalmon], [UIColor patreonCoral]];
        NSMutableArray *colorSelectorItems = [[NSMutableArray alloc] init];
        for (UIColor *color in colors) {
            CircleLineButton *colorButton = [[CircleLineButton alloc] initWithFrame:CGRectMake(0,0,35,35)];
            [colorButton drawCircleButton:color withStroke:[UIColor whiteColor]];
            [colorButton addTarget:self action:@selector(changeTextColor:) forControlEvents:UIControlEventTouchDown];
            UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0,0,40,40)];
            [buttonView addSubview:colorButton];
            [colorSelectorItems addObject:[[UIBarButtonItem alloc] initWithCustomView:buttonView]];

            // Add a UIBarButtonItem with FlexibleSpace to evenly distribute BarButtons across UIToolbar
            [colorSelectorItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
        }

        [colorSelector setItems:colorSelectorItems animated:NO];
        self.textView.inputAccessoryView = colorSelector;

        self.backgroundColorModeButton = [[TextColorModeButton alloc] init];
        self.backgroundColorModeButton.hidden = YES;
        [self addSubview:self.backgroundColorModeButton];
        [self.backgroundColorModeButton addTarget:self action:@selector(changeBackgroundColor:) forControlEvents:UIControlEventTouchDown];
        [self.backgroundColorModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            // Respect safeArea on iOS11
            if (@available(iOS 11.0, *)) {
              make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(20.f);
            } else {
              make.top.equalTo(self).offset(20.f);
            }
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        
        self.textAlignmentButton = [[TextAlignmentButton alloc] init];
        self.textAlignmentButton.hidden = YES;
        [self addSubview:self.textAlignmentButton];
        [self.textAlignmentButton addTarget:self action:@selector(changeTextAlignment) forControlEvents:UIControlEventTouchDown];
        [self.textAlignmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundColorModeButton.mas_bottom).offset(16.f);
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@32);
            make.height.equalTo(@20);
        }];

        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:@"jot" withExtension:@"bundle"];
        
        self.trashcanButton = [[UIButton alloc] init];
        [self.trashcanButton setImage:[UIImage imageNamed:@"trashcan" inBundle:[NSBundle bundleWithURL:url] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [self.trashcanButton addTarget:self action:@selector(deleteAnnotation) forControlEvents:UIControlEventTouchUpInside];
        self.trashcanButton.hidden = YES;
        [self addSubview:self.trashcanButton];

        [self.trashcanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            // Respect safeArea on iOS11
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(24.f);
            } else {
                make.top.equalTo(self).offset(24.f);
            }
            make.leading.equalTo(@24);
            make.width.equalTo(@24);
            make.height.equalTo(@24);
        }];
        
        self.textAnnotationDoneButton = [[UIButton alloc] init];
        [self.textAnnotationDoneButton setImage:[UIImage imageNamed:@"done" inBundle:[NSBundle bundleWithURL:url] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [self.textAnnotationDoneButton addTarget:self action:@selector(doneTapped) forControlEvents:UIControlEventTouchUpInside];
        self.textAnnotationDoneButton.hidden = YES;
        [self addSubview:self.textAnnotationDoneButton];
        
        [self.textAnnotationDoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            // Respect safeArea on iOS11
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(24.f);
            } else {
                make.top.equalTo(self).offset(24.f);
            }
            make.trailing.equalTo(@-24);
            make.width.equalTo(@46);
            make.height.equalTo(@19);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *note){
                                                          
                                                          [self.textContainer.layer removeAllAnimations];
                                                          
                                                          CGRect keyboardRectEnd = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
                                                          NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
                                                          
                                                          [self.textContainer mas_updateConstraints:^(MASConstraintMaker *make) {
                                                              make.top.equalTo(self).offset(-70);
                                                          }];
                                                          
                                                          CGFloat centerAboveKeyboard = keyboardRectEnd.origin.y / 2;
                                                          
                                                          [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                                                              make.top.equalTo(@(centerAboveKeyboard));
                                                          }];

                                                          [UIView animateWithDuration:duration
                                                                                delay:0.f
                                                                              options:UIViewAnimationOptionBeginFromCurrentState
                                                                           animations:^{
                                                                               [self.textContainer layoutIfNeeded];
                                                                           } completion:nil];
                                                      }];
    }
    
    return self;
}

- (void)dealloc
{
    self.textView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties

- (void)setTextString:(NSString *)textString
{
    if (![_textString isEqualToString:textString]) {
        _textString = textString;
        self.textView.text = textString;
        [self.textView setContentOffset:CGPointZero animated:NO];
    }
}

- (void)setTextEditingInsets:(UIEdgeInsets)textEditingInsets
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_textEditingInsets, textEditingInsets)) {
        _textEditingInsets = textEditingInsets;
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.textContainer).insets(textEditingInsets);
        }];
        [self.textView layoutIfNeeded];
        [self.textView setContentOffset:CGPointZero animated:NO];
    }
}

- (void)setFont:(UIFont *)font
{
    if (_font != font) {
        _font = font;
        self.textView.font = [font fontWithSize:_fontSize];
    }
}

- (void)setFontSize:(CGFloat)fontSize
{
    if (_fontSize != fontSize) {
        _fontSize = fontSize;
        self.textView.font = [_font fontWithSize:fontSize];
    }
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    if (_textAlignment != textAlignment) {
        _textAlignment = textAlignment;
        self.textView.textAlignment = textAlignment;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    if (_textColor != textColor) {
        _textColor = textColor;
        self.textView.textColor = textColor;

        // We set the tint/cursor to the same color as the text
        self.textView.tintColor = textColor;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (_backgroundColor != backgroundColor) {
        _backgroundColor = backgroundColor;
        self.textView.backgroundColor = backgroundColor;
    }
}

- (void)setClipBoundsToEditingInsets:(BOOL)clipBoundsToEditingInsets
{
    if (_clipBoundsToEditingInsets != clipBoundsToEditingInsets) {
        _clipBoundsToEditingInsets = clipBoundsToEditingInsets;
        _textView.clipsToBounds = clipBoundsToEditingInsets;
        [self setupGradientMask];
    }
}

- (void)setIsEditing:(BOOL)isEditing
{
    if (_isEditing != isEditing) {
        _isEditing = isEditing;
        self.textContainer.hidden = !isEditing;
        self.backgroundColorModeButton.hidden = !isEditing;
        self.textAlignmentButton.hidden = !isEditing;
        self.userInteractionEnabled = isEditing;
        self.trashcanButton.hidden = !isEditing;
        self.textAnnotationDoneButton.hidden = !isEditing;
        if (isEditing) {
            [self.textView becomeFirstResponder];
        } else {
            _textString = self.textView.text;
            [self.textView resignFirstResponder];
            if ([self.delegate respondsToSelector:@selector(jotTextEditViewFinishedEditingWithNewTextString:withTextColor:withBackgroundColor:withTextAlignment:)]) {
                [self.delegate jotTextEditViewFinishedEditingWithNewTextString:_textString withTextColor:_textColor withBackgroundColor:_backgroundColor withTextAlignment:self.textAlignment];
            }
        }
    }
}

#pragma mark - Gradient Mask

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupGradientMask];
}

- (void)setupGradientMask
{
    if (!self.clipBoundsToEditingInsets) {
        self.textContainer.layer.mask = self.gradientMask;
        
        CGFloat percentTopOffset = self.textEditingInsets.top / CGRectGetHeight(self.textContainer.bounds);
        CGFloat percentBottomOffset = self.textEditingInsets.bottom / CGRectGetHeight(self.textContainer.bounds);
        
        self.gradientMask.locations = @[ @(0.f * percentTopOffset),
                                         @(0.8f * percentTopOffset),
                                         @(0.9f * percentTopOffset),
                                         @(1.f * percentTopOffset),
                                         @(1.f - (1.f * percentBottomOffset)),
                                         @(1.f - (0.9f * percentBottomOffset)),
                                         @(1.f - (0.8f * percentBottomOffset)),
                                         @(1.f - (0.f * percentBottomOffset)) ];
        
        self.gradientMask.frame = CGRectMake(0.f,
                                             0.f,
                                             CGRectGetWidth(self.textContainer.bounds),
                                             CGRectGetHeight(self.textContainer.bounds));
    } else {
        self.textContainer.layer.mask = nil;
    }
}

- (CAGradientLayer *)gradientMask
{
    if (!_gradientMask) {
        _gradientMask = [CAGradientLayer layer];
        _gradientMask.colors = @[ (id)[UIColor colorWithWhite:1.f alpha:0.f].CGColor,
                                  (id)[UIColor colorWithWhite:1.f alpha:0.4f].CGColor,
                                  (id)[UIColor colorWithWhite:1.f alpha:0.7f].CGColor,
                                  (id)[UIColor colorWithWhite:1.f alpha:1.f].CGColor,
                                  (id)[UIColor colorWithWhite:1.f alpha:1.f].CGColor,
                                  (id)[UIColor colorWithWhite:1.f alpha:0.7f].CGColor,
                                  (id)[UIColor colorWithWhite:1.f alpha:0.4f].CGColor,
                                  (id)[UIColor colorWithWhite:1.f alpha:0.f].CGColor
                                  ];
    }
    
    return _gradientMask;
}

#pragma mark - Text Editing

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    if ([text isEqualToString: @"\n"]) {
        self.isEditing = NO;
        return NO;
    }
    
    if (textView.text.length + (text.length - range.length) > kCharacterLimit) {
        return NO;
    }
    
    if ([text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location != NSNotFound) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Change text color

- (void)changeTextColor:(id)sender
{
    CircleLineButton *button = (CircleLineButton *)sender;
    
    switch (self.backgroundColorModeButton.colorMode) {
        case JOTTextColorModeOpaqueBackground:
            if ([button.color isEqual:[UIColor whiteColor]]) {
                self.textColor = [UIColor patreonNavy];
            } else {
                self.textColor = [UIColor whiteColor];
            }
            
            //self.textView.backgroundColor = [self.textView.backgroundColor colorWithAlphaComponent:1.0];
            self.backgroundColor = [button.color colorWithAlphaComponent:1.0];
            break;
        
        case JOTTextColorModeTransparentBackground:
            if ([button.color isEqual:[UIColor whiteColor]]) {
                self.textColor = [UIColor patreonNavy];
            } else {
                self.textColor = [UIColor whiteColor];
            }
            
            self.backgroundColor = [button.color colorWithAlphaComponent:0.5];
            break;

        case JOTTextColorModeClearBackground:
            self.backgroundColor = [button.color colorWithAlphaComponent:0];
            self.textColor = button.color;
            break;
            
        default:
            break;
    }

}

- (void)changeBackgroundColor:(id)sender
{
    [self.backgroundColorModeButton switchToNextColorMode];
    
    switch (self.backgroundColorModeButton.colorMode) {
        case JOTTextColorModeOpaqueBackground:
            self.textColor = [UIColor patreonNavy];
            self.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:1.0];
            break;
            
        case JOTTextColorModeTransparentBackground:
            self.backgroundColor = [self.textView.backgroundColor colorWithAlphaComponent:0.5];
            self.textColor = [UIColor whiteColor];
            break;
            
        case JOTTextColorModeClearBackground:
            self.backgroundColor = [self.textView.backgroundColor colorWithAlphaComponent:0];
            break;
            
        default:
            break;
    }
    
}

- (void)changeTextAlignment {
    [self.textAlignmentButton switchToNextTextAlignment];
    
    switch (self.textAlignmentButton.textAlignment) {
        case JOTTextAlignmentCenter:
            self.textAlignment = NSTextAlignmentCenter;
            break;
            
        case JOTTextAlignmentRight:
            self.textAlignment = NSTextAlignmentRight;
            break;
            
        case JOTTextAlignmentLeft:
            self.textAlignment = NSTextAlignmentLeft;
            break;
            
        default:
            break;
    }
}

- (void)deleteAnnotation {
    self.textString = @"";
    self.isEditing = NO;
}

- (void)doneTapped {
    self.isEditing = NO;
}

#pragma mark - Change textView sizing when text changess

- (void)textViewDidChange:(UITextView *)textView
{
    [textView sizeToFit];
}

@end
