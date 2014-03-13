//
//  EDANewMessageViewController.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/13/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDANewMessageViewController.h"

#import "EDANewMessageView.h"
#import "EDANewMessageViewModel.h"

@interface EDANewMessageViewController ()

@property (nonatomic) EDANewMessageView *view;
@property (nonatomic) EDANewMessageViewModel *viewModel;

@end

@implementation EDANewMessageViewController

- (id)initWithEmployees:(NSArray *)employees {
    self = [super init];
    if (self == nil) return nil;
    
    _viewModel = [[EDANewMessageViewModel alloc] initWithEmployees:employees];
    
    self.title = @"Message";
    
    return self;
}

- (void)loadView {
    self.view = [[EDANewMessageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:nil action:nil];
    sendItem.rac_command = [_viewModel sendMessageCommandWithViewController:self];
    
    @weakify(self);
    
    [[[[sendItem.rac_command.executionSignals
        flatten]
        filter:^BOOL(NSNumber *result) {
            return result.boolValue == YES;
        }]
        flattenMap:^RACStream *(id value) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Sent" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            return [alert.rac_buttonClickedSignal take:1];
        }]
        subscribeNext:^(id x) {
            @strongify(self);
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    
    [self rac_liftSelector:@selector(handleError:) withSignals:sendItem.rac_command.errors, nil];
    
    self.navigationItem.rightBarButtonItem = sendItem;

    RAC(self.view.textView, editable) = [sendItem.rac_command.executing not];
}

- (void)viewDidLoad {
    RAC(self.viewModel, messageText) = self.view.textView.rac_textSignal;
    
    [self.view.textView becomeFirstResponder];
}

@end
