//
//  ViewController.m
//  WebServiceManager
//
//  Created by Stark Digital Media Services Pvt Ltd on 07/10/16.
//  Copyright © 2016 Stark Digital Media Services Pvt Ltd. All rights reserved.
//

#import "ViewController.h"
#import "SDWebServiceManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)fetchData:(id)sender {
    
    NSMutableDictionary *loginDict = [[NSMutableDictionary alloc] init];
    [loginDict setObject:@"abc@gmail.com"  forKey:@"email"];
    [loginDict setObject: @"123456"  forKey:@"password"];
    [loginDict setObject: @"check"  forKey:@"urlVariable"];
    
    
    [SDWebServiceManager initWithWebServiceJSON:loginDict onCompletion:^(id dataDict,NSError *error,BOOL success){
        
        if(!error){
            if (dataDict!=nil || dataDict) {
                NSLog(@"%@",dataDict);
            }
        }else
            NSLog(@"%@",error.localizedDescription);
    }];
    
    
    NSDictionary *tokenDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"value",@"key",NULL];

    NSDictionary *resultDataDict = [SDWebServiceManager sendSynchronousRequestWithUrl:@"urlstring" Method:@"POST" andData:tokenDict];
    NSLog(@"result = %@",resultDataDict);
    
    
    NSDictionary *resultData = [SDWebServiceManager sendSynchronousRequestWithUrl:@"urlstring" Method:nil andData:nil];
    NSLog(@"result = %@",resultData);

}
@end
