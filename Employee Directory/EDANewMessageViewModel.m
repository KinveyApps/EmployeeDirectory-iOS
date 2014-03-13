//
//  EDANewMessageViewModel.m
//  Employee Directory
//
//  Created by Peter Stuart on 3/13/14.
//  Copyright (c) 2014 Ballast Lane Applications. All rights reserved.
//

#import "EDANewMessageViewModel.h"

#import "EDAEmployee.h"
#import "EDAMessage+API.h"

NSString * const EDANewMessageViewModelErrorDomain = @"com.ballastlane.employeedirectory.email";

NSInteger const EDANewMessageViewModelEmailErrorCodeNotSetUp = 1;

@interface EDANewMessageViewModel () <MFMailComposeViewControllerDelegate>

@property (nonatomic) NSArray *employees;

@end

@implementation EDANewMessageViewModel

- (id)initWithEmployees:(NSArray *)employees {
    self = [super init];
    if (self == nil) return nil;

    _employees = employees;
    
    return self;
}

- (RACCommand *)sendMessageCommandWithViewController:(UIViewController *)viewController {
    RACSignal *enabled = [RACObserve(self, messageText)
        map:^NSNumber *(NSString *text) {
            return @(text.length > 0);
        }];
    
    @weakify(self);
    
    return [[RACCommand alloc] initWithEnabled:enabled signalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"How would you like your message to be sent?" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Email", @"Text", @"Email & Text", nil];
        [alert show];
        return [alert.rac_buttonClickedSignal
            flattenMap:^RACStream *(NSNumber *buttonNumber) {
                NSInteger button = buttonNumber.integerValue;
                
                BOOL text = NO;
                BOOL email = NO;
                
                if (button == 0) {
                    return [RACSignal return:@NO];
                }
                else if (button == 3) {
                    text = YES;
                    email = YES;
                }
                else if (button == 2) {
                    text = YES;
                }
                else if (button == 1){
                    email = YES;
                }
                
                RACSignal *textSignal;
                if (text == YES) {
                    RACTuple *signals = [EDANewMessageViewModel sendTextMessage:self.messageText toEmployees:self.employees];
                    textSignal = signals.first;
                    
                    RACSignal *errors = signals.second;
                    [errors subscribeNext:^(RACTuple *tuple) {
                        RACTupleUnpack(NSError *error, EDAEmployee *employee) = tuple;
                        NSLog(@"Error sending message to %@: %@", employee.cellPhone, error.localizedDescription);
                    }];
                }
                else {
                    textSignal = [RACSignal return:@YES];
                }
                
                RACSignal *emailSignal;
                if (email == YES) {
                    if ([MFMailComposeViewController canSendMail] == NO) {
                        NSError *error = [NSError errorWithDomain:EDANewMessageViewModelErrorDomain code:EDANewMessageViewModelEmailErrorCodeNotSetUp userInfo:nil];
                        emailSignal = [RACSignal error:error];
                    }
                    else {
                        NSArray *emailAddresses = [[[self.employees.rac_sequence
                            filter:^BOOL(EDAEmployee *employee) {
                                return employee.email.length > 0;
                            }]
                            map:^NSString *(EDAEmployee *employee) {
                                return employee.email;
                            }]
                            array];
                        
                        MFMailComposeViewController *mailViewController = [MFMailComposeViewController new];
                        [mailViewController setToRecipients:emailAddresses];
                        [mailViewController setSubject:@"Message"];
                        [mailViewController setMessageBody:self.messageText isHTML:NO];
                        mailViewController.mailComposeDelegate = self;
                        
                        [viewController presentViewController:mailViewController animated:YES completion:NULL];
                        
                        emailSignal = [[[self rac_signalForSelector:@selector(mailComposeController:didFinishWithResult:error:) fromProtocol:@protocol(MFMailComposeViewControllerDelegate)]
                            take:1]
                            flattenMap:^RACStream *(id value) {
                                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                                    [viewController dismissViewControllerAnimated:YES completion:^{
                                    [subscriber sendNext:@YES];
                                    [subscriber sendCompleted];
                                }];

                                return nil;
                            }];
                        }];
                    }
                }
                else {
                    emailSignal = [RACSignal return:@YES];
                }
                
                if (text == YES && email == NO) return textSignal;
                else if (text == NO && email == YES) return emailSignal;
                else return [textSignal flattenMap:^RACStream *(id value) {
                    return emailSignal;
                }];
        }];
    }];
}

/// @return A RACTuple containing the message send signal, and an errors signal. The errors signal sends tuples containing the error and the corresponding employee object.
+ (RACTuple *)sendTextMessage:(NSString *)message toEmployees:(NSArray *)employees {
    NSArray *employeesToSendTo = [[employees.rac_sequence
        filter:^BOOL(EDAEmployee *employee) {
            return employee.cellPhone.length > 0;
        }]
        array];
    
    NSArray *messageSignals = [[[employeesToSendTo.rac_sequence
        map:^EDAMessage *(EDAEmployee *employee) {
            EDAMessage *textMessage = [EDAMessage new];
            textMessage.recipientPhoneNumber = employee.cellPhone;
            textMessage.message = message;
            
            return textMessage;
        }]
        map:^RACSignal *(EDAMessage *textMessage) {
            return [[[[EDAMessage appdataStore] rac_saveObject:textMessage] publish] autoconnect];
        }]
        array];
    
    NSArray *messageSignalsWithCaughtErrors = [[messageSignals.rac_sequence
        map:^RACSignal *(RACSignal *signal) {
            return [signal catch:^RACSignal *(NSError *error) {
                if ([error.domain isEqualToString:KCSServerErrorDomain] && error.code == KCSBadRequestError) {
                    return [RACSignal return:@YES];
                }
                else {
                    return [RACSignal error:error];
                }
            }];
        }]
        array];
    
    NSArray *errorsSignals = [[messageSignals.rac_sequence
        map:^RACSignal *(RACSignal *signal) {
            return [[signal
                ignoreValues]
                catch:^RACSignal *(NSError *error) {
                    EDAEmployee *employee = employeesToSendTo[[messageSignals indexOfObject:signal]];
                    return [RACSignal return:RACTuplePack(error, employee)];
                }];
        }]
        array];
    
    RACSignal *sendSignal = [RACSignal
        combineLatest:messageSignalsWithCaughtErrors
        reduce:^id{
            return @YES;
        }];
    
    RACSignal *errors = [RACSignal merge:errorsSignals];

    return RACTuplePack(sendSignal, errors);
}

@end
