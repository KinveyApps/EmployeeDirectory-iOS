//
//  EDANewMessageView.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/13/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDANewMessageView.h"

@implementation EDANewMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil) return nil;
    
    UITextView *textView = [UITextView new];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:textView];
    self.textView = textView;
    
    YMKeyboardLayoutHelperView *helperView = [[YMKeyboardLayoutHelperView alloc] init];
    [self addSubview:helperView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(textView, helperView);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[textView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView][helperView]|" options:0 metrics:nil views:views]];
    
    return self;
}

@end
