//
//  TwitterHelper.m
//  TwitterHelper
//
//  Created by Yas Kuraishi on 3/4/14.
//
//

#import "YATTwitterHelper.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "OAuth+Additions.h"
#import "TWAPIManager.h"
#import "TWSignedRequest.h"
#import "AppDelegate.h"

#define NSErrorFromString(cd, msg) [NSError errorWithDomain:@"TwitterHelper" code:cd userInfo:@{@"NSLocalizedRecoverySuggestion": msg}]
#define NoAccountFoundError         NSErrorFromString(1, @"You must add a Twitter account in settings before using it")
#define AccessDeniedError           NSErrorFromString(2, @"You must allow Twitter access your account details")
#define UserCancelsError            NSErrorFromString(3, @"User cancelled operation")

@interface YATTwitterHelper ()

@property (nonatomic, strong) TWAPIManager  *apiManager;
@property (nonatomic, strong) NSArray       *accounts;
@property (nonatomic, copy) AuthSuccessCallback successCallback;
@property (nonatomic, copy) FailureCallback failureCallback;

@end


@implementation YATTwitterHelper

- (instancetype)initWithKey:(NSString *)consumerKey andSecret:(NSString *)consumerSecret {
    NSParameterAssert(consumerKey);
    NSParameterAssert(consumerSecret);
    
    self = [super init];
    if (self) {
        _apiManager = [TWAPIManager new];
        _apiManager.consumerKey = consumerKey;
        _apiManager.consumerSecret = consumerSecret;
    }
    return self;
}

#pragma mark - Public Operations

- (void)authWithSuccess:(AuthSuccessCallback)onSuccess failure:(FailureCallback)onError {
    self.successCallback = onSuccess;
    self.failureCallback = onError;
    
    if (![TWAPIManager isLocalTwitterAccountAvailable]) {
        if (onError) onError(NoAccountFoundError);
        return;
    }
    
    ACAccountStore *accountStore = [ACAccountStore new];
    ACAccountType *twitterType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    __weak YATTwitterHelper *weakSelf = self;
    [accountStore requestAccessToAccountsWithType:twitterType options:NULL completion:^(BOOL granted, NSError *error) {
        __unsafe_unretained YATTwitterHelper *newSelf = weakSelf;
        
        if (granted) {
            self.accounts = [accountStore accountsWithAccountType:twitterType];
            if (newSelf.accounts.count == 1) {
               newSelf.successCallback(self.accounts[0]);
            } else {
                UIActionSheet *sheet = [[UIActionSheet alloc] init];
                
                for (ACAccount *acct in self.accounts) {
                    [sheet addButtonWithTitle:acct.username];
                }
                
                sheet.delegate = newSelf;
                sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [sheet showInView:[UIApplication sharedApplication].keyWindow];
                });
            }
            
        } else {
            if (onError) onError(AccessDeniedError);
        }
    }];
}

- (void)reverseAuthWithSuccess:(ReverseAuthSuccessCallback)onSuccess failure:(FailureCallback)onError {
    [self authWithSuccess:^(ACAccount *account) {
        [self.apiManager performReverseAuthForAccount:account withHandler:^(NSData *responseData, NSError *error) {
            if (responseData) {
                NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                NSLog(@"Twitter Reverse Auth Response: %@", responseStr);
                
                NSArray *parts = [responseStr componentsSeparatedByString:@"&"];
                NSMutableDictionary *data = [NSMutableDictionary new];
                
                for (NSString *part in parts) {
                    NSArray *field = [part componentsSeparatedByString:@"="];
                    [data setValue:field[1] forKey:field[0]];
                }
                
                if (onSuccess) onSuccess(data);
            }
            else {
                NSLog(@"Twitter Reverse Auth process failed. %@\n", [error localizedDescription]);
                if (onError) onError(error);
            }
        }];
    } failure:onError];
}

#pragma mark - UIActionSheetDelgate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        self.failureCallback(UserCancelsError);
    } else {
        self.successCallback(self.accounts[buttonIndex]);
    }
}

@end
