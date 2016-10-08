//
//  WebServiceBlock.h
//  WebServiceDemo
//
//  Created by Stark Digital Media Services Pvt Ltd on 07/10/16.
//  Copyright © 2016 Stark Digital Media Services Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import "Reachability.h"

typedef void (^webServiceHandler)(id object, NSError *error, BOOL success);

@interface SDWebServiceManager : UIViewController

+ (void)initWithWebServiceJSON:(NSDictionary*)dict onCompletion:(webServiceHandler)handler;

+ (NSDictionary*)sendSynchronousRequest:(NSURLRequest*)urlRequest error:(NSError**)error;

+ (NSDictionary*)sendSynchronousRequestWithUrl:(NSString*)strUrl Method:(NSString*)method andData:(NSDictionary*)data;

- (BOOL)facebookPost:(UIViewController*)sender initialText:(NSString*)strInitialText urlIfWantToAddWhileSharing:(NSString*)strUrl;

- (BOOL)twitterPost:(UIViewController*)sender initialText:(NSString*)strInitialText;

+ (NSString*)convertDictToJsonString:(NSDictionary*)dict;

+ (void)showRechabilityError;

@end
