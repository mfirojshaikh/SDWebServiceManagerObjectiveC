//
//  WebServiceBlock.m
//  WebServiceDemo
//
//  Created by Stark Digital Media Services Pvt Ltd on 07/10/16.
//  Copyright © 2016 Stark Digital Media Services Pvt Ltd. All rights reserved.
//

#import "SDWebServiceManager.h"
#import "AppDelegate.h"

#define URLStr @""

@implementation SDWebServiceManager
UIAlertController *alertController;

/*
 * Call this method if you want to use header for basic authentication
 **/

+ (void)initWithWebServiceJSON:(NSDictionary*)dict onCompletion:(webServiceHandler)handler {
    
    NSDictionary *json = [[NSDictionary alloc] init];
    
    NSError *error;
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *loginString = @"";
    
    NSLog(@"Current rechability status %ld",(long) [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]);
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [self showRechabilityError];
        return;
    }
    // Headers
    if (dict[@"headers"] != nil) {
        headers = [dict valueForKey:@"headers"];
    }
    
    // Add variable to common URL
    if (dict[@"urlVariable"] != nil) {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",URLStr,[dict valueForKey:@"urlVariable"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        request.HTTPMethod = @"POST";
        request.allHTTPHeaderFields = headers;
    }
    
    if (dict[@"postData"]!= nil) {
        request.HTTPBody = [dict valueForKey:@"postData"];
    }
    // Login String
    loginString=[NSString stringWithFormat:@"%@:%@",[dict valueForKey:@"email"],[dict valueForKey:@"password"]];
    
    [request setValue:[NSString stringWithFormat:@"Basic %@", [[loginString dataUsingEncoding: NSUTF8StringEncoding] base64EncodedStringWithOptions:0]] forHTTPHeaderField:@"Authorization"];
    
    
    json = [SDWebServiceManager sendSynchronousRequest:request error:&error];
    
    if(json) {
        handler(json , nil , YES);
        
    }else {
        handler(nil,error,NO);
        
    }
}
/**
 send synchronousRequest using Post/Get request (send data in json format & receive in JSON format)
 please convert your input dictionary to string if your service require and pass to this function using
 a) urlString - web service url
 b) jsonString - [SDWebServiceManager   (NSString*)convertDictToJsonString:(NSDictionary*)dict];
 c) responseString- will receive any kind of error if occure
 result will be in dictionary format.
 */
+ (NSDictionary*)sendSynchronousRequestWithUrl:(NSString*)strUrl Method:(NSString*)method andData:(NSDictionary*)data
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block NSError *errorResponse;
    __block NSURLResponse *urlResponse;
    __block NSData *responseData;
    

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    if (method) {

        [request setHTTPMethod:method];
        
        if (data != nil) {
            
            // use the code as per your webserver require parameters
            
            //NSString *strData = [NSString stringWithFormat:@"data=%@",[SDWebServiceManager convertDictToJsonString:data]];
            //NSData *bodyData = [NSData dataWithBytes:[strData UTF8String] length:[strData length]];
            
            NSData *bodyData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&errorResponse];
            [request setHTTPBody:bodyData];
            
        }

    }
    else
    {
        [request setHTTPMethod:@"GET"];
    }
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        
        if (error) {
            errorResponse = error;
        }else
        {
            responseData = data;
            urlResponse = response;
        }
        dispatch_semaphore_signal(semaphore);
        
    }];
    
    [dataTask resume];
    // this code can be use for GET method

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    if (errorResponse) {
        
        NSLog(@"Response Error \n %@",errorResponse.description);
        
        NSString *strError = [NSString stringWithFormat:@"%@",errorResponse.description];
        
        [SDWebServiceManager showErrorTitle:@"Response Error" message:strError];
        
        return nil;
    }else if (responseData != nil)
    {
       NSDictionary *dictResult = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&errorResponse];
        
        if (dictResult != nil)
        {
            return dictResult;
        }
        
        NSString *strError = [NSString stringWithFormat:@"%@",errorResponse.description];
        
        [SDWebServiceManager showErrorTitle:@"Decode Error" message:strError];
        
        NSLog(@"Error while decoding result data to JSON \n %@",errorResponse.description);
        
        return nil;
    }
    return nil;
}

/*
 * this method can be used while you want set your own custome urlRequest
 * and send address of error parameter to check if any error occure.
 */

+ (NSDictionary*)sendSynchronousRequest:(NSURLRequest*)urlRequest error:(NSError**)error
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block NSError *errorResponse;
    __block NSURLResponse *urlResponse;
    __block NSData *responseData;
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        
        if (error) {
            errorResponse = error;
        }else
        {
            responseData = data;
            urlResponse = response;
        }
        dispatch_semaphore_signal(semaphore);
        
    }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    if (errorResponse) {
        
        NSLog(@"Response Error \n %@",errorResponse.description);
        
        NSString *strError = [NSString stringWithFormat:@"%@",errorResponse.description];
        
        *error = errorResponse;
        
        [SDWebServiceManager showErrorTitle:@"Response Error" message:strError];
        
        return nil;
    }else if (responseData != nil)
    {
        NSDictionary *dictResult = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&errorResponse];
        
        if (dictResult != nil)
        {
            return dictResult;
        }
        
        NSString *strError = [NSString stringWithFormat:@"%@",errorResponse.description];
        
        *error = errorResponse;
        
        [SDWebServiceManager showErrorTitle:@"Decode Error" message:strError];
        
        NSLog(@"Error while decoding result data to JSON \n %@",errorResponse.description);
        
        return nil;
    }
    return nil;
}
/*
 * convert your dictionary data to String
 */
+(NSString*)convertDictToJsonString:(NSDictionary*)dict
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];

    NSString *responseString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    return responseString;
}


/**
 share text/url to facebook
 */
-(BOOL)facebookPost:(UIViewController*)sender initialText:(NSString*)strInitialText urlIfWantToAddWhileSharing:(NSString*)strUrl{
    
    SLComposeViewController *controller = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeFacebook];
    SLComposeViewControllerCompletionHandler myBlock =
    ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled)
        {
            NSLog(@"Canceled");
        }
        else
            
        {
            NSLog(@"Done");
        }
        [controller dismissViewControllerAnimated:YES completion:nil];
    };
    controller.completionHandler = myBlock;
    //Adding the Text to the facebook post value from iOS
    [controller setInitialText:strInitialText!=nil?strInitialText:@""];
    //Adding the URL to the facebook post value from iOS
    [controller addURL:[NSURL URLWithString:strUrl!=nil?strUrl:@""]];
    //Adding the Text to the facebook post value from iOS
    [sender presentViewController:controller animated:YES completion:nil];
    return true;
}
/**
 share text to twitter
 */
- (BOOL)twitterPost:(UIViewController*)sender initialText:(NSString*)strInitialText{
   
    @try {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:strInitialText!=nil?strInitialText:@""];
        [sender presentViewController:tweetSheet animated:YES completion:nil];
        return true;
    }
    @catch (NSException *exception) {
        return false;
    }
    @finally {
        
    }

}
#pragma mark- internet connection

+ (void)showRechabilityError
{
    [SDWebServiceManager showErrorTitle:@"No network connection" message:@"Please try later"];
}

#pragma mark- web service error

+(void)showErrorTitle:(NSString*)strTitle message:(NSString*)strErrorMessage
{
    
    alertController = [UIAlertController alertControllerWithTitle:strTitle message:strErrorMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:action];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.window.rootViewController.presentedViewController
     presentViewController:alertController animated:false completion:nil];
    
}
@end
