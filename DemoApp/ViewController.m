//
//  ViewController.m
//  DemoApp
//
//  Created by Yas Kuraishi on 3/4/14.
//
//

#import "ViewController.h"
#import "YATTwitterHelper.h"
#import <Accounts/Accounts.h>

NSString *const kTWConsumerKey = @"";
NSString *const kTWConsumerSecret = @"";

@interface ViewController ()


@property (nonatomic, strong) YATTwitterHelper *twitterHelper;
@property (weak, nonatomic) IBOutlet UITextView *tokenTextView;

- (IBAction)testAuthTapped:(UIButton *)sender;
- (IBAction)reverseAuthTapped:(UIButton *)sender;

@end


@implementation ViewController

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    _twitterHelper = [[YATTwitterHelper alloc] initWithKey:kTWConsumerKey andSecret:kTWConsumerSecret];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

- (IBAction)testAuthTapped:(UIButton *)sender {
    self.tokenTextView.text = @"";
    [self.twitterHelper authWithSuccess:^(ACAccount *account) {
        self.tokenTextView.text = [NSString stringWithFormat:@"User: %@ authorized", account.accountDescription];
    } failure:^(NSError *error) {
        self.tokenTextView.text = error.description;
    }];
}

- (IBAction)reverseAuthTapped:(UIButton *)sender {
    self.tokenTextView.text = @"";
    [self.twitterHelper reverseAuthWithSuccess:^(NSDictionary *data) {
        self.tokenTextView.text = [data descriptionInStringsFileFormat];
    } failure:^(NSError *error) {
        self.tokenTextView.text = error.description;
    }];
}
@end
