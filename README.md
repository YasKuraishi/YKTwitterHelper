YKTwitterHelper
===============

Blocks based Twitter Auth and ReverseAuth to fetch `oauth_access_token` and `oauth_token_secret`. 

### Overview

This is basically a refactor of Sean Cook's [https://github.com/seancook/TWReverseAuthExample](https://github.com/seancook/TWReverseAuthExample) to make it super easy to use by simply dragging and dropping to a project. 

There are literally 3 small steps from setup to getting your `oauth_access_token` and `oauth_token_secret` from Twitter.

### How To Use

1) Drag and drop **YKTwitterHelper** folder to your project.

2) Create an instance: 
    
    YKTwitterHelper *twitterHelper = [[YKTwitterHelper alloc] initWithKey:kTWConsumerKey 
    															andSecret:kTWConsumerSecret];
    											
3) Use following method get `oauth_access_token` and `oauth_token_secret` via **reverse auth** as below:

	[twitterHelper reverseAuthWithSuccess:^(NSDictionary *data) {
        NSLog (@"%@", [data descriptionInStringsFileFormat]);
    } failure:^(NSError *error) {
        NSLog (@"%@", error.description);
    }];

   Or to simply get user authorization to access Twitter accounts configured in the system use this method instead:

	[twitterHelper authWithSuccess:^(ACAccount *account) {
		NSLog (@"%@", [NSString stringWithFormat:@"User: %@ authorized", account.accountDescription]);
	} failure:^(NSError *error) {
        NSLog (@"%@", error.description);
    }];
    

###  License

The MIT License (MIT)

Copyright (c) 2014 Yas Kuraishi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

### Credits

**TWiOSReverseAuthExample** by Sean Cook's ([@theSeanCook](http://twitter.com/theSeanCook)) - [https://github.com/seancook/TWReverseAuthExample](https://github.com/seancook/TWReverseAuthExample).

**ABOAuthCore** by Loren Brichter's ([@atebits](http://twitter.com/lorenb)) - [https://bitbucket.org/atebits/oauthcore](https://bitbucket.org/atebits/oauthcore).

