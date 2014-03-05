//
//  TwitterHelper.h
//  TwitterHelper
//
//  Created by Yas Kuraishi on 3/4/14.
//
//

#import <Foundation/Foundation.h>

@class ACAccount;

typedef void(^AuthSuccessCallback)(ACAccount *account);
typedef void(^ReverseAuthSuccessCallback)(NSDictionary *data);
typedef void(^FailureCallback)(NSError *error);

@interface YATTwitterHelper : NSObject<UIActionSheetDelegate>

/**
 Instance initializer
 
 @param consumerKey Twitter consumer key
 @param consumerSecret Twitter consumer secret
 */
- (instancetype)initWithKey:(NSString *)consumerKey andSecret:(NSString *)consumerSecret;

/**
 Asks for user authorization to access Twitter accounts configured in the system and pops up action sheet to let user pick one if there are multiple accounts.
 
 @param onSuccess Callback block that returns selected ACAccount object.
 @param onError Callback in case of an error.
 */
- (void)authWithSuccess:(AuthSuccessCallback)onSuccess failure:(FailureCallback)onError;

/**
 Asks for user authorization to access Twitter accounts configured in the system and pops up action sheet to let user pick one if there are multiple accounts and then makes a call to Twitter oAuth api to obtain oauth_token and oauth_token_secret.
 
 @param onSuccess Callback block that returns selected NSDictionary object of oauth_token and oauth_token_secret amongst others
 @param onError Callback in case of an error.
 */
- (void)reverseAuthWithSuccess:(ReverseAuthSuccessCallback)onSuccess failure:(FailureCallback)onError;

@end
