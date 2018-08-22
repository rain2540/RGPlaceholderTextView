//
//  RGPlaceholderTextView.m
//  RGPlaceholderTextView
//
//  Created by Rain on 2018/8/15.
//  Copyright © 2018年 Rain. All rights reserved.
//

#import "RGPlaceholderTextView.h"

@interface RGPlaceholderTextView()

@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *inputLimtLabel;
@property (nonatomic, strong, readonly) UIColor *placeholderDefaultColor;
@property (nonatomic, strong) NSArray<NSLayoutConstraint *> *placeholderLabelConstraints;
@property (nonatomic, assign) NSInteger inputCount;

@end

@implementation RGPlaceholderTextView

#pragma mark Getter & Setter
- (UIColor *)placeholderDefaultColor {
    return [UIColor lightGrayColor];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = self.placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor =
    self.placeholderColor != nil ? self.placeholderColor : [self placeholderDefaultColor];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    if (self.placeholderFont != nil) {
        self.placeholderLabel.font = self.font;
    }
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    UIFont *font = self.placeholderFont != nil ? self.placeholderFont : self.font;
    self.placeholderLabel.font = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    self.placeholderLabel.textAlignment = self.textAlignment;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self textDidChange];
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    [super setTextContainerInset:textContainerInset];
    [self updateConstraintsForPlaceholderLabel];
}
/*
- (void)setInputLimit:(NSInteger)inputLimit {
    _inputLimit = inputLimit;
    _inputLimtLabel.hidden = NO;
    _inputLimtLabel.text = [NSString stringWithFormat:@"%@ / %@字", @(self.inputCount), @(self.inputLimit)];
}
*/
#pragma mark Initializer
- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
    
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.textColor = self.placeholderColor;
    self.placeholderLabel.textAlignment = self.textAlignment;
    self.placeholderLabel.text = self.placeholder;
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.placeholderLabel];
    [self updateConstraintsForPlaceholderLabel];
    self.inputCount = 0;
    [self addCountLabel];
//    self.inputLimtLabel.hidden = self.inputLimit == 0;
}

#pragma mark UI
- (void)layoutSubviews {
    [super layoutSubviews];
    self.placeholderLabel.preferredMaxLayoutWidth = self.textContainer.size.width - self.textContainer.lineFragmentPadding * 2.0;
}

- (void)updateConstraintsForPlaceholderLabel {
    NSMutableArray *newConstraints = [NSMutableArray array];
    
    NSArray<NSLayoutConstraint *> *hConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[placeholder]", self.textContainerInset.left + self.textContainer.lineFragmentPadding]
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:@{@"placeholder": self.placeholderLabel}];
    [newConstraints addObjectsFromArray:hConstraints];
    
    NSArray<NSLayoutConstraint *> *vConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[placeholder]", self.textContainerInset.top]
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:@{@"placeholder": self.placeholderLabel}];
    [newConstraints addObjectsFromArray:vConstraints];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.placeholderLabel
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1.0
                                                                   constant:-(self.textContainerInset.left + self.textContainerInset.right + self.textContainer.lineFragmentPadding * 2.0)];
    [newConstraints addObject:constraint];
    
    [self removeConstraints:self.placeholderLabelConstraints];
    [self addConstraints:newConstraints];
    self.placeholderLabelConstraints = newConstraints;
}

- (void)addCountLabel {
    self.inputLimtLabel = [[UILabel alloc] init];
    self.inputLimtLabel.frame = CGRectMake(5.0, self.bounds.size.height - 5.0 - 17.0, self.bounds.size.width - 10.0, 17.0);
    self.inputLimtLabel.font = self.font;
    self.inputLimtLabel.textColor = self.placeholderColor;
    self.inputLimtLabel.textAlignment = NSTextAlignmentRight;
//    self.inputLimtLabel.text = [NSString stringWithFormat:@"%@ / %@字", @(self.inputCount), @(self.inputLimit)];
    self.inputLimtLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.inputLimtLabel];
}

#pragma mark Callback
- (void)textDidChange {
    self.placeholderLabel.hidden = ![self.text isEqualToString:@""] /*|| self.text != nil*/;
    NSString *exist = self.text;
    self.inputCount = exist.length;
//    self.inputLimtLabel.text = [NSString stringWithFormat:@"%@ / %@字", @(self.inputCount), @(self.inputLimit)];
}

#pragma mark Lifecycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:nil];
}

@end
